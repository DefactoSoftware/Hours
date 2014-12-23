class TimeSeries::WeeklyTimeSeries < TimeSeries
  def initialize(resource)
    @resource = resource
    @time_span = (6.days.ago.to_date..Date.today).freeze
  end

  def chart
    "/charts/bar_chart"
  end

  def title
    I18n.t("charts.hours_per_day")
  end
end
