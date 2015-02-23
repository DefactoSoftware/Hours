require 'csv'

class ClockwiseImporter
  def initialize(csv_path:, tenant:)
    @csv_path = csv_path
    @tenant = tenant
  end

  def import!
    Apartment::Tenant.switch @tenant
    Entry.transaction do
      CSV.foreach(@csv_path,
                  headers: true,
                  quote_char: '"',
                  col_sep: ';') do |r|
        row = ImportRow.new(r)
        EntryBuilder.new(row).create! unless row.hours < 1
      end
    end
  end
end

class EntryBuilder
  def initialize(row)
    @row = row
  end

  def create!
    client = build_client
    project = build_project(client)
    category = build_category
    user = build_user
    Entry.create!(
      project: project,
      category: category,
      user: user,
      hours: @row.hours,
      date: @row.date,
      description: @row.description,
    )
  end

  private

  def build_client
    Client.where('lower(name) = ?', @row.client)
      .first_or_create(name: @row.client)
  end

  def build_project(client)
    Project.where('lower(name) = ?', @row.project.downcase)
      .first_or_create(name: @row.project,
                       billable: true,
                       client: client,
                       archived: @row.archive)
  end

  def build_category
    Category.where('lower(name) = ?', @row.category.downcase)
      .first_or_create(name: @row.category)
  end

  def build_user
    names = @row.user.split(' ')
    first_name = names.first
    last_name = names.last
    full_name = { first_name: first_name, last_name: last_name }
    User.find_or_create_by(full_name) do |user|
      user.email = build_email_from_name(@row.user)
      user.password = SecureRandom.hex
      user.confirmed_at = DateTime.now
    end
  end

  def build_email_from_name(name)
    names = name.split(' ')
    "#{names[0][0]}.#{names[1]}@defacto.nl".downcase
  end
end

class ImportRow
  attr_reader :archive,
              :user,
              :client,
              :project,
              :category,
              :date,
              :hours,
              :description

  def initialize(row)
    @archive = row[0] == 'J'
    @user = row[1]
    @client = row[2]
    if row[3].to_s.empty?
      @project = row[2]
    else
      @project = row[3]
    end
    @category = row[4]
    @date = parse_date(row[7])
    @hours = row[8].to_s.gsub(',','.').to_f.round
    @description = String(row[9]).truncate(255)
  end

  private

  def parse_date(date_string)
    comps = date_string.split('/')
    year = Integer('20' + comps[2].last(2))
    month = Integer(comps[1])
    day = Integer(comps[0])
    DateTime.new(year, day, month)
  end
end
