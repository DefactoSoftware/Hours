class CategoriesController < ApplicationController
  before_action :find_category, only: [:edit, :update]
  def index
    set_index_params
  end

  def create
    @new_category = Category.new(category_params)
    if @new_category.save
      redirect_to categories_path, notice: t(:category_created)
    else
      set_index_params
      redirect_to categories_path,
                  notice: @new_category.errors.full_messages.join(" ")
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: t(:category_updated)
    else
      render :edit
    end
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def set_index_params
    @category = Category.new
    @categories = Category.by_name
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
