class ClientsController < ApplicationController
  def show
    @projects = resource.projects.by_last_updated.page(params[:page]).per(3)
    @time_series = time_series_for(resource)
  end

  def index
    @client = Client.new
    @clients = Client.by_name
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to clients_path, notice: t(:client_created)
    else
      @clients = Client.by_name
      render "clients/index"
    end
  end

  def edit
    resource
  end

  def update
    if resource.update_attributes(client_params)
      redirect_to clients_path, notice: t(:client_updated)
    else
      render :edit
    end
  end

  private

  def resource
    @client ||= Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:name, :description, :logo)
  end
end
