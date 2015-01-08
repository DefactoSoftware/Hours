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
