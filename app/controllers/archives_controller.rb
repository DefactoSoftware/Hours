class ArchivesController < ApplicationController
  def update
    resource.archived = !resource.archived
    resource.save
    redirect_to root_path, notice: resource.archived ? t("project_archived") : t("project_unarchived")
  end

  def index
    @projects = Project.are_archived
  end

  private

  def resource
    @project ||= Project.find_by_slug(params[:id])
  end
end