# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  hour_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

describe Tagging do
  describe "validations" do
    it { should validate_presence_of :tag }
    it { should validate_presence_of :hour }
  end

  describe "associations" do
    it { should belong_to :tag }
    it { should belong_to :hour }
  end
end
