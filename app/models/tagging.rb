# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  entry_id   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tagging < ActiveRecord::Base
  belongs_to :tag
  belongs_to :entry

  validates :tag, presence: true
  validates :entry, presence: true
end
