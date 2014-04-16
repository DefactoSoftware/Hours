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
  belongs_to :project
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  scope :by_name, -> { order("lower(name)") }

  def percentage_spent_on(project)
    (hours_spent(project).to_f / hours_spent_on(project) * 100).round
  end

  def hours_spent(project)
    hours_spent_on_entries(Entry.where(category: self, project: project))
  end

  private

  def hours_spent_on(project)
    hours_spent_on_entries(project.entries)
  end

  def hours_spent_on_entries(entries)
    entries.sum(:hours)
  end
end
