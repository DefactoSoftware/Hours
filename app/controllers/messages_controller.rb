class MessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  
  def create
    @message = Message.new(message_params)
    if @message.valid?
      @message.save
      redirect_to root_path, notice: t("helpful.success_message")
    else
      redirect_to root_path, notice: t("helpful.error_message")
    end
  end

  private

  def message_params
    params.permit(:name, :title, :body, :email)
  end
end