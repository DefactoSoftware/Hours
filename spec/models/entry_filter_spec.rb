describe EntryFilter do
  it "sets params" do
    filter = EntryFilter.new({ client_id: 1 })

    expect(filter.client_id).to eq(1)
  end

  it "#clients" do
    filter = EntryFilter.new

    client1 = create(:client, name: "Zack")
    client2 = create(:client, name: "Andy")
    clients = [client2, client1]

    expect(filter.clients).to eq clients
  end

  it "#users" do
    filter = EntryFilter.new

    user1 = create(:user, last_name: "Simpson")
    user2 = create(:user, last_name: "Burns")
    users = [user2, user1]

    expect(filter.users).to eq users
  end

  it "#projects" do
    filter = EntryFilter.new

    project1 = create(:project, name: "Learning Spaces")
    project2 = create(:project, name: "Defacto")
    projects = [project2, project1]

    expect(filter.projects).to eq projects
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
