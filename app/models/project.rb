# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string
#  budget      :integer
#  billable    :boolean          default("false")
#  client_id   :integer
#  archived    :boolean          default("false"), not null
#  description :text
#

class Project < ActiveRecord::Base
  include Sluggable

  audited allow_mass_assignment: true

  validates :name, presence: true,
                   uniqueness: { case_sensitive: false }
  validates_with ClientBillableValidator
  has_many :hours
  has_many :mileages
  has_many :users, -> { uniq }, through: :hours
  has_many :categories, -> { uniq }, through: :hours
  has_many :tags, -> { uniq }, through: :hours
  belongs_to :client, touch: true

  scope :by_last_updated, -> { order("projects.updated_at DESC") }
  scope :by_name, -> { order("lower(name)") }

  scope :are_archived, -> { where(archived: true) }
  scope :unarchived, -> { where(archived: false) }
  scope :billable, -> { where(billable: true) }

  def sorted_categories
    categories.sort_by do |category|
      EntryStats.new(hours, category).percentage_for_subject
    end.reverse
  end

  def label
    name
  end

  def budget_status
    budget - hours.sum(:value) if budget
  end

  def has_billable_entries?
    hours.exists?(billed: false) ||
      mileages.exists?(billed: false)
  end

  private

  def slug_source
    name
  end
end
