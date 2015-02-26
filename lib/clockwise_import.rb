require "csv"

class ClockwiseImporter
  def initialize(csv_path:, tenant:)
    @csv_path = csv_path
    @tenant = tenant
    Apartment::Tenant.switch @tenant
  end

  def import!
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

  def cleanup!
    ActiveRecord::Base.transaction do
      Project.where("name in (?)", PROJECTS_TO_REMOVE).each do |project|
        project.entries.each do |entry|
          entry.destroy!
        end
        project.destroy!
      end
      Category.find_each do |cat|
        if cat.entries.length == 0
          cat.destroy!
        end
      end
      Tag.find_each do |tag|
        if tag.entries.length == 0
          tag.destroy!
        end
      end
      Client.find_each do |client|
        if client.projects.length == 0
          client.destroy!
        end
      end
    end
  end

  def reset_updated_at!
    ActiveRecord::Base.transaction do
      Project.find_each do |project|
        if project.entries.length != 0
          project.update_attributes(
            updated_at: find_most_recent_entry_date(project))
        end
      end
    end
  end

  def find_most_recent_entry_date(project)
    date = project.entries.order(:date).last.date
    DateTime.parse date.to_s
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
      billed: @row.archive
    )
  end

  private

  def build_client
    Client.where("lower(name) = ?", @row.client.downcase).
      first_or_create(name: @row.client)
  end

  def build_project(client)
    Project.where("lower(name) = ? or slug = ?",
                  @row.project.downcase,
                  @row.project.parameterize).
      first_or_create(name: @row.project,
                      billable: true,
                      client: client,
                      archived: @row.archive)
  end

  def build_category
    Category.where("lower(name) = ?", @row.category.downcase).
      first_or_create(name: @row.category)
  end

  def build_user
    names = @row.user.split(' ')
    first_name = names.first
    last_name = names.last
    User.where("lower(first_name) = ? and lower(last_name) = ?",
               first_name.downcase, last_name.downcase).
                first_or_create(first_name: first_name,
                                last_name: last_name,
                                email: build_email_from_name(@row.user),
                                password: SecureRandom.hex,
                                confirmed_at: DateTime.now)
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
    @archive = row[0] == "J"
    @user = row[1]
    @client = row[2]

    if row[3].to_s.empty? || row[2].downcase == "defacto"
      @project = row[2]
    else
      @project = row[3]
    end

    if row[4].to_s.empty?
      @category = "Clockwise Import"
    else
      @category = row[4]
    end

    @date = parse_date(row[7])
    @hours = parse_full_hours(row[8])
    @description = String(row[9]).truncate(255)
  end

  private

  def parse_date(date_string)
    comps = date_string.split('/')
    year = Integer('20' + comps[2].last(2))
    day = Integer(comps[1])
    month = Integer(comps[0])
    DateTime.new(year, month, day)
  end

  def parse_full_hours(hours_string)
    String(hours_string).gsub(',', '.').to_f.round
  end
end

PROJECTS_TO_REMOVE = [
  "Activite CAPP Upgrade",
  "de Jong & Laan",
  "Gelre Ziekenhuis",
  "ZuidZorg",
  "De Nederlandsche Bank",
  "MCL",
  "ZINN Zorggroep",
  "Beweging 3.0",
  "Luchtvaartcollege Schiphol",
  "NFI",
  "LUMC",
  "MUMC",
  "KvK",
  "Amarant meerwerk upgrade project",
  "Spaarne Gasthuis",
  "Ministerie OCW - DUO",
  "Phoenix",
  "Karakter: meerwerk implementatie",
  "Maxima Medisch Centrum",
  "Equens",
  "OZG",
  "Schiphol_ROC ondersteuning SSO Focus-CAPP",
  "Karakter implementatie CAPP11",
  "FOCUS - TU DELFT",
  "Amarant upgrade CAPP11",
  "VTC",
  "DNB",
  "ZZG Zorggroep",
  "KPN Consultancy",
  "Den Haag",
  "Sociale Verzekeringsbank (SVB)",
  "STMR Implementatie CAPP11",
  "TUI",
  "Ministerie SZW",
  "Kwintes",
  "Sogeti: upgrade naar CAPP11",
  "SFG"
]
