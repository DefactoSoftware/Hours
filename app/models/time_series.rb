class TimeSeries
  YEARLY = (364.days.ago.to_date..Date.today).freeze
  MONTHLY = (29.days.ago.to_date..Date.today).freeze
  WEEKLY = (6.days.ago.to_date..Date.today).freeze

  def initialize(entries: nil, time_span: nil)
    @time_span = time_span
    @hours_per_day = hours_per_day(entries)
  end

  def serialize
    {
      labels: @time_span.map { |date| date.strftime('%d/%m') },
      datasets: [
        {
          data: @time_span.map { |date| @hours_per_day[date] || 0 }
        }
      ]
    }
  end

  def days
    @time_span.count
  end

  private

  def hours_per_day(entries)
    entries.order("DATE(date)").group("DATE(date)").sum(:hours)
  end
end
