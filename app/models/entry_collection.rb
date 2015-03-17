class EntryCollection
  def initialize(hours, mileages)
    @hours = hours
    @mileages = mileages
  end

  def total_hours
    @hours.sum(:value)
  end

  def total_unbilled_hours
    @hours.where(billed: false).sum(:value)
  end

  def total_billed_hours
    @hours.where(billed: true).sum(:value)
  end

  def total_mileages
    @mileages.sum(:value)
  end

  def total_unbilled_mileages
    @mileages.where(billed: false).sum(:value)
  end

  def total_billed_mileages
    @mileages.where(billed: true).sum(:value)
  end
end
