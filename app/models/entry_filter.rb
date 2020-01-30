# frozen_string_literal: true

class EntryFilter
  include ActiveModel::Model

  KEYS = %i[
    client_id
    project_id
    user
    billed
    to_date
    from_date
    archived
    billable
  ].freeze

  attr_accessor(*KEYS)

  def initialize(params = {})
    params = params&.slice(*KEYS)
    super(params)
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

  def clients
    @clients ||= Client.by_name
  end

  def users
    @users ||= User.by_name
  end

  def projects
    @projects ||= Project.by_name
  end
end
