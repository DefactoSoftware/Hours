# == Schema Information
#
# Table name: taggings
#
#  id         :integer          not null, primary key
#  tag_id     :integer
#  entry_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Tagging do
  describe "validations" do
    it { should validate_presence_of :tag }
    it { should validate_presence_of :entry }
  end

  describe "associations" do
    it { should belong_to :tag }
    it { should belong_to :entry }
  end
end
