require "spec_helper"
require "csv"

describe EntryCSVGenerator do
  let(:first_entry) { build_stubbed(:entry) }
  let(:second_entry) { build_stubbed(:entry) }
  let(:generator) { EntryCSVGenerator.new([first_entry, second_entry]) }

  it "generates csv" do
    csv = generator.generate
    expect(csv).to include(
      "Date,User,Project,Category,Client,Hours,Billable,Billed,Description")
    expect(csv.lines.count).to eq(3)
    expect(csv.lines.last.split(",").count).to eq(9)
  end

  it "localizes the separator" do
    I18n.locale = :nl
    expect(generator.options).to include(col_sep: ";")
    I18n.locale = I18n.default_locale
    expect(generator.options).to include(col_sep: ",")
  end
end
