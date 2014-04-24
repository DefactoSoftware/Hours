require "spec_helper"

describe RemainingCategory do
  let(:project) { create(:project) }
  let(:category) { create(:category) }

  before(:each) do
    5.times do
      create(:entry, project: project)
    end
  end

  let(:remaining_category) do
    RemainingCategory.new(project.sorted_categories.drop(3))
  end

  describe "#hours_spent" do
    it "returns the hours spent" do
      expect(remaining_category.hours_spent(project)).to eq(2)
    end
  end

  describe "#percentage_spent" do
    it "returns the percentage spent" do
      expect(remaining_category.percentage_spent_on(project)).to eq(40)
    end
  end

  it "has a gray name" do
    expect(remaining_category.name.pastel_color).to eq("#BEBEBE")
  end
end
