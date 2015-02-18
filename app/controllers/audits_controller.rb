require "audit_history"

class AuditsController < ApplicationController
  def index
    @history = AuditHistory.new(audit_log)
  end

  private

  def audit_log
    if params.key?(:hour_id)
      return Hour.find(params[:hour_id]).audits
    end

    if params.key?(:mileage_id)
      return Mileage.find(params[:mileage_id]).audits
    end

    if params.key?(:project_id)
      return Project.find_by_slug(params[:project_id]).audits
    end
  end
end
