require "audit_history"

class AuditsController < ApplicationController
  def index
      @history = AuditHistory.new(audit_log)
  end

  private

  def audit_log
    if params.key?(:entry_id)
      return Entry.find(params[:entry_id]).audits
    end

    if params.key?(:project_id)
      return Project.find_by_slug(params[:project_id]).audits
    end
  end
end
