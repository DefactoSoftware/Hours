require "spec_helper"

describe EntryFilter do
  it "sets params" do
    filter = EntryFilter.new({ client_id: 1 })

    expect(filter.client_id).to eq(1)
  end

  it "#clients" do
    filter = EntryFilter.new

    expect(filter.clients).to eq(Client.by_name)
  end

  it "#projects" do
    filter = EntryFilter.new

    expect(filter.projects).to eq(Project.unarchived.by_name)
  end

  it "billed_options" do
    filter = EntryFilter.new

    expect(filter.billed_options).to eq([
      [I18n.t("billables.filters.not_billed"), false],
      [I18n.t("billables.filters.billed"), true]
    ])
  end
end
