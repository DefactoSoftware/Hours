class TagsController < ApplicationController
  def show
    @entries = tag.entries.by_date.page(params[:page]).per(10)
    @tag = tag
  end

  private

  def tag
    @tag ||= Tag.find_by_slug(params[:id].downcase)
  end
end
