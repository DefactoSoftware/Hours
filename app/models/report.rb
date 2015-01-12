class Report
  def initialize(entries)
    @entries = entries.map { |e| ReportEntry.new(e) }
  end

  def headers
    %w(date user project category client hours billable billed description).map do |header|
      I18n.translate("report.headers.#{header}")
    end
  end

  def each_row(&block)
    @entries.each(&block)
  end
end
