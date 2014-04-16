# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

require "spec_helper"

describe Category do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }

    it "should validate case insensitive uniqueness" do
      create(:category, name: "software development")
      expect(build(:category, name: "Software Development")).to_not be_valid
    end
  end

  describe "#by_name" do
    it "orders by name case insensitive" do
      create(:category, name: "B")
      a = create(:category, name: "a")
      expect(Category.by_name.first).to eq(a)
    end
  end

  describe "#hours spent" do
    it "returns the hours spent" do
      entry = create(:entry, hours: 2)

      expect(entry.category.hours_spent(entry.project)).to eq(2)
    end
  end

  describe "#percentage spent" do
    it "returns the percentage spent" do
      project = create(:project)
      entry = create(:entry, hours: 2, project: project)
      create(:entry, hours: 3, project: project)

      expect(entry.category.percentage_spent_on(entry.project)).to eq(40)
    end
  end
end
