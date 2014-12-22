# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#  billable   :boolean          default(FALSE)
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
      EntryStats.new(entries, category).percentage_for_subject
    end.reverse
  end

  def label
    name
  end

  private

  def slug_source
    name
  end
end
