class BillablesController < ApplicationController
  def index
    @projects = Project.all.billable
  end
end
