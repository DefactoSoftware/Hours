class EntryQuery
  def initialize(entries, params, entry_type)
    @entries = entries.extending(Scopes)
    Scopes.set(entry_type)
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
    value != "" && !value.nil?
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
      where("#{Scopes.get}.date >= ?", Date.parse(param.to_s))
    end

    def to_date(param)
      where("#{Scopes.get}.date <= ?", Date.parse(param.to_s))
    end

    def archived(param)
      joins(:project).where("archived = ?", param)
    end

    def billable(param)
      joins(:project).where("billable = ?", param)
    end

    def self.set(entry_type)
      @entry_type = entry_type
    end

    def self.get
      @entry_type
    end
  end
end
