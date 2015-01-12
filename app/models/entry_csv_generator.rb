require "csv"

class EntryCSVGenerator
  def self.generate(entries)
    new(entries).generate
  end

  def initialize(entries)
    @report = Report.new(entries)
  end

  def generate
    CSV.generate do |csv|
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
end
