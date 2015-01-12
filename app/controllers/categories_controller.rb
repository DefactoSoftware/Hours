class CategoriesController < ApplicationController
  before_action :find_category, only: [:edit, :update]

  def index
    @category = Category.new
    @categories = Category.by_name
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: t(:category_created)
    else
      @categories = Category.by_name
      render "categories/index"
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

  def category_params
    params.require(:category).permit(:name)
  end
end
