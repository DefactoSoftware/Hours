# == Schema Information
#
# Table name: entries
#
#  id          :integer          not null, primary key
#  project_id  :integer          not null
#  category_id :integer          not null
#  user_id     :integer          not null
#  hours       :integer          not null
#  date        :date             not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Entry < ActiveRecord::Base
  belongs_to :project, touch: true
  belongs_to :category
  belongs_to :user, touch: true
  has_many :taggings, inverse_of: :entry
  has_many :tags, through: :taggings

  validates :user, presence: true
  validates :project, presence: true
  validates :category, presence: true
  validates :hours, presence: true,
                    numericality: { greater_than: 0 }
  validates :date, presence: true
  accepts_nested_attributes_for :taggings

  scope :by_last_created_at, -> { order("created_at desc") }
  scope :by_date, -> { order("date DESC") }

  def tag_list
    tags.map(&:name).join(", ")
  end

  def tag_list=(names)
    self.tags = names.split(",").map do |n|
      Tag.where("name ILIKE ?", n.strip).first_or_initialize.tap do |tag|
        tag.name = n.strip
        tag.save!
      end
    end
  end
end
