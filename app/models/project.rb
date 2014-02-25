class Project < ActiveRecord::Base
  validates :name, presence: true
  validates :account, presence: true

  belongs_to :account
end
