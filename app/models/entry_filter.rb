class EntryFilter
  include ActiveModel::Model

  KEYS = [
    :client_id,
    :project_id,
    :user,
    :billed,
    :to_date,
    :from_date,
    :archived,
    :billable
  ].freeze

  attr_accessor(*KEYS)
  attr_reader :projects, :clients, :users

  def initialize(params = {})
    super(Params.new(params))
    @clients = Client.by_name
    @projects = Project.by_name
    @users = User.by_name
  end

  def billed_options
    [
      [I18n.t("entry_filters.not_billed"), false],
      [I18n.t("entry_filters.billed"), true]
    ]
  end

  def billable_options
    [
      [I18n.t("entry_filters.not_billable"), false],
      [I18n.t("entry_filters.billable"), true]
    ]
  end

  def archived_options
    [
      [I18n.t("entry_filters.not_archived"), false],
      [I18n.t("entry_filters.archived"), true]
    ]
  end

  def from_date
    DateTime.parse(@from_date) if @from_date.present?
  end

  def to_date
    DateTime.parse(@to_date) if @to_date.present?
  end
end

class EntryFilter
  class Params
    def initialize(hash)
      @params = filter(hash) || []
    end

    def rejecting_nil
      @params.reject { |_, value| value.nil? }
    end

    def each(&block)
      @params.each(&block)
    end

    private

    def filter(hash)
      hash.slice(*KEYS) if hash
    end
  end
end
