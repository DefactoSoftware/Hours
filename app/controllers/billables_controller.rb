class BillablesController < ApplicationController
  def index
    hours = query("hours")
    mileages = query("mileages")
    @billable_list = BillableList.new(hours, mileages)
    @filters = EntryFilter.new(entry_filter_or_default)
  end

  def bill_entries
    if params[:entries_to_bill]
      params[:entries_to_bill].each do |value|
        entry_type = value.split("-")[0]
        entry_id = value.split("-")[1]
        entry = to_object(entry_type).find(entry_id)
        entry.update_attribute(:billed, true)
      end
    end
    render json: nil, status: 200
  end

  private

  def entry_filter_or_default
    params[:entry_filter] || { billed: false }
  end

  def query(entry_type)
    EntryQuery.new(
      resource(entry_type),
      entry_filter_or_default,
      entry_type
    ).filter
  end

  def resource(entry_type)
    instance_variable_set(
      "@#{entry_type}_entries",
      to_object(entry_type).
      includes(resource_params(entry_type)).billable
    )
  end

  def resource_params(entry_type)
    resource_params = [:user, :project]
    resource_params.push (:category) if entry_type == "hours"
  end
end
