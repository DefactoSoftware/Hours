describe EntryFilter do
  it "sets params" do
    filter = EntryFilter.new({ client_id: 1 })

    expect(filter.client_id).to eq(1)
  end

  it "#clients" do
    filter = EntryFilter.new
    create_list(:client, 2)

    expect(filter.clients).to eq Client.by_name
  end

  it "#users" do
    filter = EntryFilter.new
    create_list(:user, 2)

    expect(filter.users).to eq User.by_name
  end

  it "#projects" do
    filter = EntryFilter.new
    create_list(:project, 2)

    expect(filter.projects).to eq Project.by_name
  end

  it "#billed_options" do
    filter = EntryFilter.new

    billed_options = [
      [I18n.t("entry_filters.not_billed"), false],
      [I18n.t("entry_filters.billed"), true]
    ]

    expect(filter.billed_options).to eq(billed_options)
  end

  it "#billable_options" do
    filter = EntryFilter.new

    billable_options = [
      [I18n.t("entry_filters.not_billable"), false],
      [I18n.t("entry_filters.billable"), true]
    ]

    expect(filter.billable_options).to eq(billable_options)
  end

  it "#archived_options" do
    filter = EntryFilter.new

    archived_options = [
      [I18n.t("entry_filters.not_archived"), false],
      [I18n.t("entry_filters.archived"), true]
    ]

    expect(filter.archived_options).to eq(archived_options)
  end

  describe "#from_date" do
    it "is a DateTime" do
      filter = EntryFilter.new(from_date: "14/10/2017")
      expect(filter.from_date).to eq DateTime.parse("14/10/2017")
    end

    it "is nil when there is no from_date" do
      filter = EntryFilter.new
      expect(filter.from_date).to be_nil
    end
  end

  describe "#to_date" do
    it "is a DateTime" do
      filter = EntryFilter.new(to_date: "14/10/2017")
      expect(filter.to_date).to eq DateTime.parse("14/10/2017")
    end

    it "is nil when there is no to_date" do
      filter = EntryFilter.new
      expect(filter.to_date).to be_nil
    end
  end
end
