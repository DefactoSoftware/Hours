class TimeSeries
  YEARLY = (364.days.ago.to_date..Date.today).freeze
  MONTHLY = (29.days.ago.to_date..Date.today).freeze
  WEEKLY = (6.days.ago.to_date..Date.today).freeze
  DAILY = ()

  def initialize(entries: nil, time_span: nil)
    @entries = entries
    @time_span = time_span
  end

  def serialize
    {
      labels: @time_span.map { |date| date.strftime('%d/%m') },
      datasets: [
        {
          data: @time_span.map { |date| hours_per_day[date] || 0 }
        }
      ]
    }
  end

  def days
    @time_span.count
  end

  def entries_for_time_span
    @entries.where(created_at: @time_span)
  end

  def yearly?
    @time_span == YEARLY
  end

  private

  def hours_per_day
    @hours_per_day ||= @entries.order("DATE(date)").group("DATE(date)").sum(:hours)
  end
end
