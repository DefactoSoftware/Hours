include TimeSeriesInitializer

class ProjectsController < ApplicationController
  def index
    @projects = Project.by_last_updated.page(params[:page]).per(7)
    @entry = Entry.new
    @activities = Entry.by_last_created_at.limit(30)
  end

  def show
    @time_series = time_series_for(resource)
  end

  def edit
    resource
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      redirect_to root_path, notice: t(:project_created)
    else
      render action: "new"
    end
  end

  def update
    if resource.update_attributes(project_params)
      redirect_to project_path(resource), notice: t(:project_updated)
    else
      render action: "edit"
    end
  end

  private

  def resource
    @project ||= Project.find_by_slug(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :billable, :client_id)
  end
end
