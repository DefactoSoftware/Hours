class EntryQuery
  def initialize(entries, params)
    @entries = entries
    @params = params
  end

  def filter
    build_filters.each do |filter|
      @entries = @entries.where(filter)
    end
    @entries
  end

  private

  def filter_params
    @params[:filters].slice(:client_id, :project_id, :from_date, :to_date, :billed)
  end

  def build_filters
    [between, client, project, billed]
  end

  def between
    to_date = filter_params[:to_date].empty? ? DateTime.now : filter_params[:to_date]
    from_date = filter_params[:from_date].empty? ? DateTime.new : filter_params[:from_date]
    {created_at: from_date..to_date}
  end

  def client
    # {client_id: filter_params[:client_id]} if filter_params[:client_id].present?
    # need to join project but that breaks the rest
  end

  def project
    {project_id: filter_params[:project_id]} if !filter_params[:project_id].empty?
  end

  def billed
    {billed: filter_params[:billed]} if !filter_params[:billed].empty?
  end
end
