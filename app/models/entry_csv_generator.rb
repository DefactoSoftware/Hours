require "csv"

class EntryCSVGenerator
  def self.generate(entries)
    new(entries).generate
  end

  def initialize(entries)
    @entries = entries
  end

  def generate
    CSV.generate do |csv|
      csv << columns
      @entries.each do |entry|
        csv << row(entry)
      end
    end
  end

  private

  def columns
    %w(date user project category client hours billable description).map(&:capitalize)
  end

  def row(entry)
    [
      entry.date,
      entry.user.full_name,
      entry.project.name,
      entry.category.name,
      entry.project.client.try(:name),
      entry.hours,
      entry.project.billable,
      entry.description
    ]
  end
end
