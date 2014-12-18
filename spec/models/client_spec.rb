# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#

require "spec_helper"

describe Client do
  let(:client) { create(:client) }

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end

  describe "associations" do
    it { should have_many :projects }
  end

  describe "#by_name" do
    it "orders by name case insensitive" do
      create(:client, name: "B")
      a = create(:client, name: "a")
      expect(Client.by_name.first).to eq(a)
    end
  end
end
