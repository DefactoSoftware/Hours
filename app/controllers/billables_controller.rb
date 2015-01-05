class BillablesController < ApplicationController
  include Filterable

  def index
    resource
    @entries = filter_collection(resource) if params[:filters]
    @projects = Project.all
    @clients = Client.all
  end

  def bill_entries
    params[:entries_to_bill].each do |entry_id|
      Entry.find(entry_id).update_attribute(:billed, true)
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
