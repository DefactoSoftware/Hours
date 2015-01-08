class BillablesController < ApplicationController
  def index
    entries = EntryQuery.new(resource, params[:filters]).filter
    @billable_list = BillableList.new(entries)
  end

  def bill_entries
    if params[:entries_to_bill]
      params[:entries_to_bill].each do |entry_id|
        entry = Entry.find(entry_id)
        entry.update_attribute(:billed, true)
      end
    end
    redirect_to billables_path
  end

  private

  def resource
    @entries ||= Entry.billable
  end
end
