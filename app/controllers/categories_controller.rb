class CategoriesController < ApplicationController
  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to root_path, notice: I18n.t(:category_created)
    else
      render action: "new"
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
