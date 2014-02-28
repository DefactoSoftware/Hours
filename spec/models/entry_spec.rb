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
  end
end
