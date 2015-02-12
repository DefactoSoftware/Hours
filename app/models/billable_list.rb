class BillableList
  attr_reader :clients

  def initialize(entries)
    @entries = entries
    @clients = Client.eager_load(projects: [entries: [:user, :category]]).where(
      "entries.id in (?)", entries.map(&:id)
    ).by_last_updated
  end
end
