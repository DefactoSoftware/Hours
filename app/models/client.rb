# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#

class Client < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  scope :by_name, -> { order("lower(name)") }
  has_many :projects
end
