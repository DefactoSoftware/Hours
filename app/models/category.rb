# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
