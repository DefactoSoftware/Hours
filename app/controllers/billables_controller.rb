class BillablesController < ApplicationController
  def index
    entries = EntryQuery.new(resource, entry_filter_or_default).filter
    @billable_list = BillableList.new(entries)
    @filters = EntryFilter.new(entry_filter_or_default)
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

  def entry_filter_or_default
    params[:entry_filter] || { billed: false }
  end

  def resource
    @entries ||= Entry.includes(:category, :user).billable
  end
end
