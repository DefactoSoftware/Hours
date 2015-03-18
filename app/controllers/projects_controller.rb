include TimeSeriesInitializer

class ProjectsController < ApplicationController
  def index
    @projects = Project.search(filter).page(params[:page]).per(7)
    @hours_entry = Hour.new
    @mileages_entry = Mileage.new
    @activities = Hour.by_last_created_at.limit(30)

    respond_to do |format|
      format.html { }
      format.json {
        projects = Project.unarchived
        if !params[:client_id].empty?
          projects = projects.by_client(params[:client_id])
        end
        render :json => projects, :only => [:name, :client_id, :id]
      }
    end
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

  def filter
    if !params[:list].nil?
      params[:list][:search]
    end
  end

  def resource
    @project ||= Project.find_by_slug(params[:id])
  end

  def project_params
    params.require(:project).
      permit(:name, :billable, :client_id, :archived, :description, :budget)
  end
end
