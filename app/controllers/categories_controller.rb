class CategoriesController < ApplicationController
  def index
    set_index_params
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: t(:category_created)
    else
      set_index_params
      redirect_to categories_path,
                  notice: @category.errors.full_messages.join(" ")
    end
  end

  private

  def set_index_params
    @new_category = Category.new
    @categories = Category.by_name
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
