class Report
  def initialize(entries)
    @entries = entries.map { |e| ReportEntry.new(e) }
  end

  def headers(entry_type)
    header = if entry_type == "mileages"
               %w[date user project client mileages billable billed]
             else
               %w[
                 date
                 user
                 project
                 category
                 client
                 hours
                 billable
                 billed
                 description
               ]
             end
    header.map do |headers|
      I18n.translate("report.headers.#{headers}")
    end
  end

  def each_row(&block)
    @entries.each(&block)
  end
end
