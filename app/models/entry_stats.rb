class EntryStats
  def initialize(entries, subject = nil)
    @entries = entries
    @subject = subject
  end

  def percentage_spent_on
    (hours_spent_on.to_f / hours_spent.to_f * 100).round
  end

  def hours_spent_on
    entries.sum(:hours)
  end

  def hours_spent
    @entries.sum(:hours)
  end

  def hours_per(collection)
    collection.map do |subject|
      @subject = subject
      {
        value: hours_spent_on,
        color: subject.label.pastel_color,
        label: subject.label,
        highlight: "gray"
      }
    end
  end

  private

  def entries
    if @subject.instance_of?(RemainingCategory)
      @entries.where("category_id in (?)", @subject.ids)
    else
      @entries.where("#{@subject.class.name.downcase}_id = (?)", @subject.id)
    end
  end
end
