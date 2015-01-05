class Report
  def initialize(entries)
    @entries = entries.map { |e| ReportEntry.new(e) }
  end

  def headers
    %w(date user project category client hours billable description).map(&:capitalize)
  end

  def each_row(&block)
    @entries.each(&block)
  end
end

class ReportEntry
  def initialize(entry)
    @entry = entry
  end

  def date
    @entry.date
  end

  def user
    @entry.user.full_name
  end

  def project
    @entry.project.name
  end

  def category
    @entry.category.name
  end

  def client
    @entry.project.client.try(:name)
  end

  def hours
    @entry.hours
  end

  def billable
    @entry.project.billable
  end

  def description
    @entry.description
  end
end
