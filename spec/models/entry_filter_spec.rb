describe EntryFilter do
  it "sets params" do
    filter = EntryFilter.new({ client_id: 1 })

    expect(filter.client_id).to eq(1)
  end

  it "#clients" do
    filter = EntryFilter.new
    expect(Client).to receive(:by_name)
    filter.clients
  end

  it "#users" do
    filter = EntryFilter.new
    expect(User).to receive(:by_name)
    filter.users
  end

  it "#projects" do
    filter = EntryFilter.new
    expect(Project).to receive(:by_name)
    filter.projects
  end

  it "billed_options" do
    filter = EntryFilter.new

    expect(filter.billed_options).to eq([
      [I18n.t("entry_filters.not_billed"), false],
      [I18n.t("entry_filters.billed"), true]
    ])
  end
end
