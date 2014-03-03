# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require "spec_helper"

describe Tag do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }

    it "validates uniqueness of name case insensitive" do
      create(:tag, name: "Client A")
      expect(build(:tag, name: "client a")).to_not be_valid
    end
  end

  describe "associations" do
    it { should have_many :taggings }
    it { should have_many :entries }
  end
end
