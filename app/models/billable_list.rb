class BillableList
  attr_reader :clients
  def initialize(entries)
    @entries = entries
    @projects = Project.where(id: @entries.map(&:project_id)).by_last_updated
    @clients = Client.where(id: @entries.map { |entry| entry.client.id }).by_last_updated
  end

  def entries_for_project(project)
    @entries.where(project: project)
  end

  def projects_for_client(client)
    @projects.where(client: client)
  end
end
