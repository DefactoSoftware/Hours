class ProjectPresenter
  NUMBER_OF_ACTIVITIES = 4
  attr_reader :template
  def initialize(project, template)
    @project = project
    @template = template
  end

  def show_categories
    template.render partial: "category",
                    collection: categories_with_remainder,
                    locals: { project: @project }
  end

  def show_categories_bar
    template.render partial: "categories_bar",
                    as: :category,
                    collection: categories_with_remainder,
                    locals: { project: @project }
  end

  private

  def sorted_categories
    @project.sorted_categories
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
