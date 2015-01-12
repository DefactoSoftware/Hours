require "spec_helper"

describe EntryCSVGenerator do
  it "generates csv" do
    first_entry = build_stubbed(:entry)
    second_entry = build_stubbed(:entry)
    data = [].tap do |d|
      d << first_entry
      d << second_entry
    end

    csv = EntryCSVGenerator.new(data).generate
    expect(csv).to include(
      "Date,User,Project,Category,Client,Hours,Billable,Billed,Description")
    expect(csv.lines.count).to eq(3)
    expect(csv.lines.last.split(",").count).to eq(9)
  end
end
