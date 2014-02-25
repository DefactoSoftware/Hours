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
