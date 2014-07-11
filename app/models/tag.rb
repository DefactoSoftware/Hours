# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }

  has_many :taggings
  has_many :entries, through: :taggings
  belongs_to :project

  def self.list
    Tag.order(:name).map { |t| { tag: t.name } }
  end

  def hours_for(project)
    entries.where(project: project).sum(:hours)
  end
end
