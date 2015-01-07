class EntryQuery
  def initialize(entries, params)
    @entries = entries.extending(Scopes)
    @params = params
  end

  def filter
    result = entries
    filter_params.each do |filter, value|
      result = result.public_send(filter, value) if value != "" && value != nil
    end
    result
  end

  private

  attr_reader :entries, :params

  def filter_params
    params ? params.slice(:client_id, :project_id, :billed, :to_date, :from_date).reject { |_, value| value.nil? } : []
  end

  module Scopes
    def client_id(param)
      joins(:project).where("client_id = ?", param)
    end

    def project_id(param)
      where(project_id: param)
    end

    def billed(param)
      where(billed: param)
    end

    def from_date(param)
      where("entries.created_at > ?", param)
    end

    def to_date(param)
      where("entries.created_at < ?", param)
    end
  end
end
