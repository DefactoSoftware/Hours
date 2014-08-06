class ProjectsController < ApplicationController
  def index
    @projects = Project.by_last_updated.page(params[:page]).per(7)
    @entry = Entry.new
    @activities = Entry.by_last_created_at.limit(30)
  end

  def show
    @project = Project.find_by_slug(params[:id])
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

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
