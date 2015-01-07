class CreateLogos < ActiveRecord::Migration
  def change
    add_attachment :clients, :logo
  end
end
