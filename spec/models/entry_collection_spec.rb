require "spec_helper"

describe EntryCollection do
  value1 = 75
  value2 = 125

  let!(:hour1) { create(:hour, billed: true, value: value1) }
  let!(:hour2) { create(:hour, billed: false, value: value2) }

  let!(:mileage1) { create(:mileage, billed: true, value: value1) }
  let!(:mileage2) { create(:mileage, billed: false, value: value2) }

  collection = EntryCollection.new(Hour.all, Mileage.all)

  it "sums up hours" do
    expect(collection.total_hours).to equal(value1 + value2)
  end

  it "sums up billed hours" do
    expect(collection.total_billed_hours).to equal(value1)
  end

  it "sums up unbilled hours" do
    expect(collection.total_unbilled_hours).to equal(value2)
  end

  it "sums up all mileages" do
    expect(collection.total_mileages).to equal(value1 + value2)
  end

  it "sums up billed mileages" do
    expect(collection.total_billed_mileages).to equal(value1)
  end

  it "sums up unbilled mileages" do
    expect(collection.total_unbilled_mileages).to equal(value2)
  end
end
