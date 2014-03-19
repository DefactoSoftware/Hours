module Api
  class EntriesController < ApplicationController

    def index
      @entries = Entry.all
      render json: @entries
    end

    def default_serializer_options
      {
        root: false
      }
    end
  end
end
