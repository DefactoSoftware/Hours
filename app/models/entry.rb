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
#  description :string(255)
#

class Entry < ActiveRecord::Base
  include Twitter::Extractor

  belongs_to :project, touch: true
  belongs_to :category
  belongs_to :user, touch: true
  has_many :taggings, inverse_of: :entry
  has_many :tags, through: :taggings

  validates :user, presence: true
  validates :project, presence: true
  validates :category, presence: true
  validates :hours, presence: true,
                    numericality: { greater_than: 0, only_integer: true }
  validates :date, presence: true
  accepts_nested_attributes_for :taggings

  scope :by_last_created_at, -> { order("created_at desc") }
  scope :by_date, -> { order("date DESC") }

  before_save :set_tags_from_description

  def tag_list
    tags.map(&:name).join(", ")
  end

  private

  def set_tags_from_description
    tagnames = extract_hashtags(description)
    self.tags = tagnames.map do |tagname|
      Tag.where("name ILIKE ?", tagname.strip).first_or_initialize.tap do |tag|
        tag.name = tagname.strip
        tag.save!
      end
    end
  end
end
