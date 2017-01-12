class BillablesController < ApplicationController
  def index
    @projects = projects_with_billable_entries
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

  def projects_with_billable_entries
    billable_projects = Project.where(billable: true, archived: false)

    billable_projects.select do |project|
      project unless
        project.hours.where(billed: false).empty? &&
        project.mileages.where(billed: false).empty?
    end
  end
end
