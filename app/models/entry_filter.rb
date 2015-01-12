class EntryFilter
  include ActiveModel::Model

  attr_accessor :client_id,
    :project_id,
    :from_date,
    :to_date,
    :billed

  attr_reader :clients, :projects

  def initialize(params = {})
    super(filter params)
    @clients = Client.by_name
    @projects = Project.unarchived.by_name
  end

  def billed_options
    [
      [I18n.t("billables.filters.not_billed"), false],
      [I18n.t("billables.filters.billed"), true]
    ]
  end

  private

  def filter(params)
    params.slice(:client_id, :project_id, :from_date, :to_date, :billed) if params
  end
end
