class ArchivesController < ApplicationController
  def index
    @projects = Project.are_archived.by_last_updated
  end

  private

  def resource
    @project ||= Project.find_by_slug(params[:id])
  end
end
