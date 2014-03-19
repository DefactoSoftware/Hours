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
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  has_many :entries
  has_many :users, -> { uniq }, through: :entries
  has_many :categories, -> { uniq }, through: :entries
  has_many :tags, -> { uniq }, through: :entries

  def sorted_categories
    categories.sort_by do |category|
      percentage_spent_on(category)
    end.reverse
  end

  def hours_spent
    hours_spent_on_entries(entries)
  end

  def percentage_spent_on(category)
    (hours_spent_on(category).to_f / hours_spent * 100).round
  end

  def hours_per_user
    users.map do |user|
      { value: user.hours_spent_on(self), color: user.full_name.pastel_color }
    end
  end

  def hours_spent_on(category)
    hours_spent_on_entries(entries.where(category: category))
  end


  private

  def hours_spent_on_entries(entries)
    entries.map(&:hours).reduce(0, :+)
  end
end
