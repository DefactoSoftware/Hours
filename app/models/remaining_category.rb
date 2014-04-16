class RemainingCategory
  def initialize(categories)
    @categories = categories
  end

  def name
    I18n.t("category.remaining")
  end

  def hours_spent(project)
    hours_spent_on_entries(project.entries)
  end

  def percentage_spent_on(project)
    percentage = 0
    @categories.each do |category|
      percentage += (hours_spent_on.to_f / hours_spent(project) * 100).round
    end
    percentage
  end

  def hours_spent_on
    hours = 0
    @categories.each do |category|
      hours += hours_spent_on_entries(Entry.where(category: category))
    end
    hours
  end

  private

  def hours_spent_on_entries(entries)
    entries.map(&:hours).reduce(0, :+)
  end
end
