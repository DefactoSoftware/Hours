# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

class Project < ActiveRecord::Base
  include Sluggable

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  has_many :entries
  has_many :users, -> { uniq }, through: :entries
  has_many :categories, -> { uniq }, through: :entries
  has_many :tags, -> { uniq }, through: :entries

  scope :by_last_updated, -> { order("updated_at DESC") }
  scope :by_name, -> { order("lower(name)") }

  def sorted_categories
    categories.sort_by do |category|
      category.percentage_spent_on(self)
    end.reverse
  end

  def hours_spent
    hours_spent_on_entries(entries)
  end

  def hours_per_user
    users.map do |user|
      { value: user.hours_spent_on(self), color: user.full_name.pastel_color }
    end
  end

  private

  def hours_spent_on_entries(entries)
    entries.sum(:hours)
  end

  def slug_source
    name
  end
end
