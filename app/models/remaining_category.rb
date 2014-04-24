class RemainingCategory
  def initialize(categories)
    @categories = categories
  end

  def name
    GrayName.new(I18n.t("category.remaining"))
  end

  def percentage_spent_on(project)
    (hours_spent(project).to_f / hours_spent_on(project) * 100).round
  end

  def hours_spent(project)
    hours = 0
    @categories.each do |category|
      hours += hours_spent_on_entries(Entry.where(category: category,
                                                  project: project))
    end
    hours
  end

  private

  def hours_spent_on(project)
    hours_spent_on_entries(project.entries)
  end

  def hours_spent_on_entries(entries)
    entries.sum(:hours)
  end

  class GrayName
    def initialize(name)
      @name = name
    end

    def to_s
      @name
    end

    def pastel_color
      "#BEBEBE"
    end
  end
end
