require "audit_history"

class AuditsController < ApplicationController
  def index
    @history = AuditHistory.new(Entry.find(params[:entry_id]).audits)
  end
end
