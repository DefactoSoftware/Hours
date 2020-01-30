# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string           default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class Category < ApplicationRecord
  belongs_to :project
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  scope :by_name, -> { order("lower(name)") }
  has_many :hours

  def label
    name
  end
end
