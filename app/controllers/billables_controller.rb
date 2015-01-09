class BillablesController < ApplicationController
  def index
    entries = EntryQuery.new(resource, params[:entry_filter]).filter
    @billable_list = BillableList.new(entries)
    @filters = EntryFilter.new(params[:entry_filter])
  end

  def bill_entries
    if params[:entries_to_bill]
      params[:entries_to_bill].each do |entry_id|
        entry = Entry.find(entry_id)
        entry.update_attribute(:billed, true)
      end
    end
    render json: nil, status: 200
  end

  private

  def resource
    @entries ||= Entry.billable
  end
end
