require "audit_history"

class AuditsController < ApplicationController
  def index
    @history = AuditHistory.new(audit_log)
  end

  private

  def audit_log
    case
    when params.key?(:hour_id)
      return hour_log
    when params.key?(:mileage_id)
      return mileage_log
    when params.key?(:project_id)
      return project_log
    end
  end

  def hour_log
    Hour.find(params[:hour_id]).audits
  end

  def mileage_log
    Mileage.find(params[:mileage_id]).audits
  end

  def project_log
    Project.find_by_slug(params[:project_id]).audits
  end
end
