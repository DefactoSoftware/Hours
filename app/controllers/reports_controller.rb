class ReportsController < ApplicationController
  include CSVDownload

  def index
    @filters = EntryFilter.new(params[:entry_filter])
    @entries = entries

    respond_to do |format|
      format.html
      format.csv { send_csv(name: current_subdomain, entries: @entries) }
    end
  end

  private

  def entries
    entries = EntryQuery.new(Entry.by_date, params[:entry_filter]).filter
    if params[:format] == "csv"
      entries
    else
      entries.page(params[:page]).per(20)
    end
  end
end
