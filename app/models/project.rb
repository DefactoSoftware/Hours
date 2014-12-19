# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#  budget     :integer
#  billable   :boolean          default(FALSE)
#  client_id  :integer
#  archived   :boolean          default(FALSE), not null
#

class Project < ActiveRecord::Base
  include Sluggable

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  has_many :entries
  has_many :users, -> { uniq }, through: :entries
  has_many :categories, -> { uniq }, through: :entries
  has_many :tags, -> { uniq }, through: :entries
  belongs_to :client

  scope :by_last_updated, -> { order("updated_at DESC") }
  scope :by_name, -> { order("lower(name)") }
  scope :are_archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }

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
