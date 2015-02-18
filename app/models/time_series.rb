class TimeSeries
  def self.weekly(resource)
    WeeklyTimeSeries.new(resource)
  end

  def self.monthly(resource)
    MonthlyTimeSeries.new(resource)
  end

  def self.yearly(resource)
    YearlyTimeSeries.new(resource)
  end

  def serialize
    {
      labels: labels,
      datasets: [
        {
          data: data
        }
      ]
    }
  end

  def days
    @time_span.count
  end

  def entries_for_time_span
    @resource.hours.where(created_at: range_for_entries)
  end

  private

  def range_for_entries
    ((@time_span.first + 1.day)..(@time_span.last + 1.day))
  end

  def labels
    @time_span.map { |date| date.strftime("%d/%m") }
  end

  def data
    @time_span.map { |date| hours_per_day[date] || 0 }
  end

  def hours_per_day
    @hours_per_day ||=
      @resource.hours.order("DATE(date)").group("DATE(date)").sum(:value)
  end
end
