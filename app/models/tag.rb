# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#

class Tag < ActiveRecord::Base
  include Sluggable

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  has_many :taggings
  has_many :entries, through: :taggings
  has_many :projects, -> { uniq }, through: :entries
  has_many :users, -> { uniq }, through: :entries
  belongs_to :project

  def self.list
    Tag.order(:name).pluck(:name)
  end

  private

  def slug_source
    name
  end

  def hours_per_user
    users.map do |user|
      {
        value: hours_spent_on_user(user),
        color: user.full_name.pastel_color,
        label: user.full_name,
        highlight: "gray"
      }
    end
  end

  def hours_per_project
    projects.map do |project|
      {
        value: hours_spent_on_project(project),
        color: project.name.pastel_color,
        highlight: "gray",
        label: project.name
      }
    end
  end

  def hours_spent_on_user(user)
    entries.where(user: user).sum(:hours)
  end

  def hours_spent_on_project(project)
    entries.where(project: project).sum(:hours)
  end

  def percentage_spent_on_project(project)
    hours_spent_on_project(project).to_f / hours_spent.to_f * 100
  end

  def percentage_spent_on_user(user)
    hours_spent_on_user(user).to_f / hours_spent.to_f * 100
  end

  def hours_spent
    entries.sum(:hours)
  end

  private

  def slug_source
    name
  end
end
