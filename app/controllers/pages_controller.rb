class PagesController < ApplicationController
  skip_before_action :authenticate_user!
  include HighVoltage::StaticPage

  layout "landing"
end
