class TimeSeries::MonthlyTimeSeries < TimeSeries
  def initialize(resource)
    @resource = resource
    @time_span = (29.days.ago.to_date..Date.today).freeze
  end

  def chart
    "/charts/bar_chart"
  end
end
