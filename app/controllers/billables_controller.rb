class BillablesController < ApplicationController
  def index
    @hours_entries = Hour.query(entry_filter_or_default,
                                [:user, :project, :category]).by_date
    @mileages_entries = Mileage.query(entry_filter_or_default,
                                      [:user, :project]).by_date
    @billable_list = BillableList.new(@hours_entries, @mileages_entries)
    @filters = EntryFilter.new(entry_filter_or_default)
  end

  def update
    Mileage.where(id: params[:mileages_ids]).update_all(billed: params[:billed])
    Hour.where(id: params[:hours_ids]).update_all(billed: params[:billed])
    redirect_to :back
  end

  private

  def entry_filter_or_default
    params[:entry_filter] || { billed: false }
  end
end
