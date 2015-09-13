# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string
#

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
    it { should have_many :hours }
  end
end
