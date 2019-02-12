class ProjectPresenter < BasePresenter
  NUMBER_OF_ACTIVITIES = 4

  def show_categories
    template.render partial: "projects/category",
                    collection: categories_with_remainder,
                    locals: { project: @model }
  end

  def show_categories_bar
    template.render partial: "projects/categories_bar",
                    as: :category,
                    collection: categories_with_remainder,
                    locals: { project: @model }
  end

  private

  def sorted_categories
    @model.sorted_categories
  end

  def categories_with_remainder
    categories = sorted_categories
    if sorted_categories.length > NUMBER_OF_ACTIVITIES + 1
      categories = sorted_categories.take(NUMBER_OF_ACTIVITIES)
      remaining_categories = sorted_categories.drop(NUMBER_OF_ACTIVITIES)
      categories << RemainingCategory.new(remaining_categories)
    end
    categories
  end
end
