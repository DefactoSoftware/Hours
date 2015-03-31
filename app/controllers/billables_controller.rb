class BillablesController < ApplicationController
  def index
    @hours_entries = Hour.query(entry_filter_or_default,
                                [:user, :project, :category])
    @mileages_entries = Mileage.query(entry_filter_or_default,
                                      [:user, :project])

    @billable_list = BillableList.new(@hours_entries, @mileages_entries)
    @filters = EntryFilter.new(entry_filter_or_default)
  end

  def bill_entries
    if params[:hours_to_bill]
      Hour.where(id: params[:hours_to_bill]).update_all("billed = true")
    end

    if params[:mileages_to_bill]
      Mileage.where(id: params[:mileages_to_bill]).update_all("billed = true")
    end
    render json: nil, status: 200
  end

  private

  def entry_filter_or_default
    params[:entry_filter] || { billed: false }
  end
end
