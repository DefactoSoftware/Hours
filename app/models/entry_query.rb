class EntryQuery
  def initialize(entries, params)
    @entries = entries.extending(Scopes)
    @params = params
  end

  def filter
    result = entries
    filter_params.each do |filter, value|
      result = result.public_send(filter, value) if present?(value)
    end
    result
  end

  private

  attr_reader :entries, :params

  def filter_params
    EntryFilter::Params.new(params).rejecting_nil
  end

  def present?(value)
    value != "" && value != nil
  end

  module Scopes
    def client_id(param)
      joins(:project).where("client_id = ?", param)
    end

    def project_id(param)
      where(project_id: param)
    end

    def user(param)
      where(user_id: param)
    end

    def billed(param)
      where(billed: param)
    end

    def from_date(param)
      where("entries.date >= ?", param)
    end

    def to_date(param)
      where("entries.date <= ?", param)
    end

    def archived(param)
      joins(:project).where("archived = ?", param)
    end
  end
end
