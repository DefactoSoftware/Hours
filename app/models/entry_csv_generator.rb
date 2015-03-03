require "csv"

class EntryCSVGenerator
  def self.generate(entries)
    new(entries).generate
  end

  def initialize(entries)
    @report = Report.new(entries)
  end

  def generate
    CSV.generate(options) do |csv|
      csv << @report.headers
      @report.each_row do |entry|
        csv << [
          entry.date,
          entry.user,
          entry.project,
          entry.category,
          entry.client,
          entry.hours,
          entry.billable,
          entry.billed,
          entry.description
        ]
      end
    end
  end

  def options
    return {
      col_sep: ";"
    } if I18n.locale.in?([:nl, :de])

    CSV::DEFAULT_OPTIONS
  end
end
