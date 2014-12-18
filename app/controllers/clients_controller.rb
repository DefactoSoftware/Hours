class ClientsController < ApplicationController
  def show
    resource
    @entries = resource.entries.by_date.page(params[:page]).per(10)
    @projects = resource.projects.by_last_updated.page(params[:page]).per(3)
  end

  def index
    set_index_params
  end

  def create
    @new_client = Client.new(client_params)
    if @new_client.save
      redirect_to clients_path, notice: t(:client_created)
    else
      set_index_params
      redirect_to clients_path,
                  notice: @new_client.errors.full_messages.join(" ")
    end
  end

  def edit
    resource
  end

  def update
    resource
    if @client.update_attributes(client_params)
      redirect_to clients_path, notice: t(:client_updated)
    else
      render :edit
    end
  end

  private

  def resource
    @client ||= Client.find(params[:id])
  end

  def set_index_params
    @client = Client.new
    @clients = Client.by_name
  end

  def client_params
    params.require(:client).permit(:name, :description, :logo)
  end
end
