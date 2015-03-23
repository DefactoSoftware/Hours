class BillableList
  attr_reader :clients, :hours_entries, :mileages_entries

  def initialize(hours_entries, mileages_entries)
    @hours_entries = hours_entries
    @mileages_entries = mileages_entries

    @clients = Client.eager_load(
      projects: [hours: [:user, :category],
                 mileages: [:user]]).where(
                   "hours.id in (?) OR mileages.id in (?)",
                   hours_entries.map(&:id),
                   mileages_entries.map(&:id)
    ).by_last_updated
  end
end
