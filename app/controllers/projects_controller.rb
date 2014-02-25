class ProjectsController < ApplicationController
  def index
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.account = current_account
    if @project.save
      redirect_to root_path, notice: I18n.t(:project_created)
    else
      render action: "new"
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
