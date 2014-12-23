module TimeSeriesInitializer
  def time_series_for(resource)
    case params[:time_span]
    when "weekly" then TimeSeries.weekly(resource)
    when "yearly" then TimeSeries.yearly(resource)
    else TimeSeries.monthly(resource)
    end
  end
end
