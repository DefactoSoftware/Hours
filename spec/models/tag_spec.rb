# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
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

  let(:tag) { create(:tag) }
  let(:project) { create(:project) }
  let(:user) { create(:user) }

  describe "#hours_for" do
    context "with no entries" do
      it "returns 0" do
        expect(tag.hours_for(project)).to eq(0)
      end
    end

    context "with entries" do
      it "returns the hours spent" do
        create(:entry, hours: 2, project: project).tags << tag
        create(:entry, hours: 3, project: project).tags << tag
        expect(tag.hours_for(project)).to eq(5)
      end
    end
  end

  describe "#percentage_spent_on_user" do
    context "with entries with this user" do
      it "returns the percentage of hours spent" do
        create(:entry, hours: 2, project: project, user: user).tags << tag
        create(:entry, hours: 2, project: project).tags << tag
        expect(tag.percentage_spent_on_user(user)).to eq(50)
      end
    end
  end

  describe "#percentage_spent_on_project" do
    context "with entries in this project" do
      it "returns the percentage of hours spent" do
        create(:entry, hours: 2, project: project).tags << tag
        create(:entry, hours: 2).tags << tag
        expect(tag.percentage_spent_on_project(project)).to eq(50)
      end
    end
  end

  describe "#hours_spent" do
    context "with no entries" do
      it "returns 0" do
        expect(tag.hours_spent).to eq(0)
      end
    end

    context "with entries tagged" do
      it "returns the hours spent" do
        create(:entry, hours: 2, project: project).tags << tag
        create(:entry, hours: 3, project: project).tags << tag
        expect(tag.hours_spent).to eq(5)
      end
    end

    context "with only part of entries tagged" do
      it "returns the hours spent" do
        create(:entry, hours: 3).tags << tag
        create(:entry, hours: 4).tags << tag
        create(:entry, hours: 3)
        create(:entry, hours: 2)
        expect(tag.hours_spent).to eq(7)
      end
    end
  end

end
