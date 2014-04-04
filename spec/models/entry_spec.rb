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

require 'spec_helper'

describe Entry do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :project }
    it { should validate_presence_of :category }
    it { should validate_presence_of :hours }
    it { should validate_presence_of :date }
    it { should validate_numericality_of(:hours).is_greater_than(0) }
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
      tagging = create(:tagging)
      tag = tagging.tag
      entry = tagging.entry
      tag2 = create(:tagging, entry: entry).tag
      expect(entry.tag_list).to eq("#{tag.name}, #{tag2.name}")
    end
  end

  describe "#taglist=" do
    let(:entry) { create(:entry) }
    it "takes a strint of comma separated values and sets the tags" do
      existing_tag = create(:tag)
      entry.tag_list = "#{existing_tag.name}, New Tag"
      expect(entry.tag_list).to eq("#{existing_tag.name}, New Tag")
    end

    it "removes any tagging that is left out" do
      entry.tag_list = "tag1, tag2, tag3, tag4"
      entry.tag_list = "tag1, tag3"
      expect(entry.tag_list).to eq("tag1, tag3")
    end

    it "finds the tag case insensitive" do
      entry.tag_list = "tdd"
      expect {
        entry.tag_list = "TDD"
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
