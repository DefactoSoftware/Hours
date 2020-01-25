require "audit_history"

class AuditsController < ApplicationController
  def index
    @history = AuditHistory.new(audit_log)
  end

  private

  def audit_log
    if params.key?(:hour_id)
      hour_log
    elsif params.key?(:mileage_id)
      mileage_log
    elsif params.key?(:project_id)
      project_log
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
