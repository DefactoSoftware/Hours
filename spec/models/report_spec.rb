require "spec_helper"

describe ReportEntry do
  let(:entry) { create(:entry_with_client) }
  subject(:report_entry) { ReportEntry.new(entry) }

  it "#date" do
    expect(report_entry.date).to eq(entry.date)
  end

  it "#user" do
    expect(report_entry.user).to eq(entry.user.name)
  end

  it "#project" do
    expect(report_entry.project).to eq(entry.project.name)
  end

  it "#category" do
    expect(report_entry.category).to eq(entry.category.name)
  end

  it "#client" do
    expect(report_entry.client).to eq(entry.project.client.name)
  end

  it "#hours" do
    expect(report_entry.hours).to eq(entry.hours)
  end

  it "#billable" do
    expect(report_entry.billable).to eq(entry.project.billable)
  end

  it "#description" do
    expect(report_entry.description).to eq(entry.description)
  end
end
