class ReportsController < ApplicationController
  include CSVDownload

  def index
    @filters = EntryFilter.new(params[:entry_filter])
    @hours_entries = entries("hours")
    @mileages_entries = entries("mileages")

    respond_to do |format|
      format.html
      format.csv do
        send_csv(
          name: current_subdomain,
          hours_entries: @hours_entries,
          mileages_entries: @mileages_entries)
      end
    end
  end

  private

  def entries(entry_type)
    entries = EntryQuery.new(
      to_object(entry_type).by_date,
      params[:entry_filter],
      entry_type
    ).filter
    if params[:format] == "csv"
      entries
    else
      entries.page(params[:page]).per(20)
    end
  end
end
