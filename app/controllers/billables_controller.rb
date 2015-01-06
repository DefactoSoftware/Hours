class BillablesController < ApplicationController
  include Filterable

  def index
    if params[:filters]
      @entries = filter_collection(resource)
    else
      resource
    end
    @projects = Project.by_last_updated
    @clients = Client.by_last_updated
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

  def filter_params
    params[:filters].slice(:client_id, :project_id, :from_date, :to_date, :billed)
  end
end
