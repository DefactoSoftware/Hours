require "csv"

class ClockwiseImporter
  def initialize(path)
    @csv_path = path
  end

  def import!
    Apartment::Tenant.switch :defacto
    Entry.transaction do
      CSV.foreach(@csv_path, headers: true) do |r|
        row = ImportRow.new(r[0].split(";"))
        EntryBuilder.new(row).create!
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
      billed: @row.billed
    )
  end

  private

  def build_client
    Client.find_or_create_by(name: @row.client)
  end

  def build_project(client)
    Project.find_or_create_by(name: @row.project) do |project|
      project.billable = true
      project.client = client
    end
  end

  def build_category
    Category.find_or_create_by(name: @row.category)
  end

  def build_user
    names = @row.user.split(" ")
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
    names = name.split(" ")
    "#{names[0][0]}.#{names[1]}@defacto.nl".downcase
  end
end

class ImportRow
  attr_reader :billed,
              :user,
              :client,
              :project,
              :category,
              :date,
              :hours,
              :description

  def initialize(row)
    @billed = row[0] == "inactief"
    @user = row[1]
    @client = row[2]
    @project = row[3]
    @category = row[4]
    @date = parse_date(row[7])
    @hours = Integer(row[8])
    @description = String(row[9]).truncate(255)
  end

  private

  def parse_date(date_string)
    comps = date_string.split("/")
    year = Integer("20" + comps[2].last(2))
    month = Integer(comps[1])
    day = Integer(comps[0])
    DateTime.new(year, day, month)
  end
end
