class TagsController < ApplicationController
  before_filter :load_time_series, only: [:show]

  def show
    @tag = resource
  end

  private

  def resource
    @tag ||= Tag.find_by_slug(params[:id].downcase)
  end
end
