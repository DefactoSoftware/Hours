# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  account_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Project do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :account }
  end

  describe "associations" do
    it { should belong_to :account }
  end
end
