# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  account_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  validates :name, presence: true
  validates :account, presence: true

  belongs_to :account
end
