class AuditsController < ApplicationController
  def index
    @audits = Entry.find(params[:entry_id]).audits
  end
end
