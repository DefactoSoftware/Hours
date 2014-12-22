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

require 'spec_helper'

describe Entry do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :project }
    it { should validate_presence_of :category }
    it { should validate_presence_of :hours }
    it { should validate_presence_of :date }
    it { should validate_numericality_of(:hours).is_greater_than(0) }
    it { should validate_numericality_of(:hours).only_integer }
  end

  describe "associations" do
    it { should belong_to :project }
    it { should belong_to :category }
    it { should belong_to :user }
    it { should have_many :taggings }
    it { should have_many :tags }
  end

  describe "#tag_list" do
    it "returns a string of comma separated values" do
      entry = create(:entry, description: "#omg #hashtags")
      expect(entry.tag_list).to eq("omg, hashtags")
    end
  end

  describe "tags from the description" do
    let(:entry) { build(:entry) }

    it "parses the tags from the description" do
      entry.description = "Did some #opensource #scala, mostly for #research"
      entry.save
      expect(entry.tags.size).to eq(3)
      expect(entry.tag_list).to eq("opensource, scala, research")
    end

    it "removes any tagging that is left out" do
      entry.description = "#hashtags!"
      entry.save
      entry.description = "#omgomg"
      entry.save
      expect(entry.tag_list).to eq("omgomg")
    end

    it "updates the tag when the casing changes" do
      entry.description = "did some #tdd"
      entry.save
      expect {
        entry.description = "did some #TDD"
        entry.save
      }.to_not raise_error
      expect(Tag.last.name).to eq("TDD")
      expect(entry.reload.tag_list).to include("TDD")
    end
  end

  describe "#by_last_created_at" do
    it "orders the entries by created_at" do
      create(:entry)
      last_entry = create(:entry)
      expect(Entry.by_last_created_at.first).to eq(last_entry)
    end
  end

  describe "#by_date" do
    it "orders the entries by date (latest first)" do
      create(:entry, date: Date.new(2014, 01, 01))
      latest = create(:entry, date: Date.new(2014, 03, 03))
      create(:entry, date: Date.new(2014, 02, 02))

      expect(Entry.by_date.first).to eq(latest)
    end
  end
end
