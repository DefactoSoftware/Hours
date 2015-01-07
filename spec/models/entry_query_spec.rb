require "spec_helper"

describe EntryQuery do
  let(:client) { create(:client) }
  let(:project) { create(:project, client: client) }
  let(:entry) { create(:entry, billed: false, project: project, created_at: 20.days.ago) }
  let(:entry2) { create(:entry, billed: true, created_at: 10.days.ago) }

  describe "#filter" do
    it "filters the entries on project id" do
      entry2.reload
      params = { project_id: entry.project.id }
      entry_query = EntryQuery.new(Entry.all, params)

      expect(entry_query.filter.count).to eq(1)
    end

    it "filters the entries on client_id" do
      entry2.reload
      params = { client_id: entry.client.id }
      entry_query = EntryQuery.new(Entry.all, params)

      expect(entry_query.filter.count).to eq(1)
    end

    it "filters the entries on from_date" do
      entry2.reload
      params = { to_date: entry.created_at + 1.day }
      entry_query = EntryQuery.new(Entry.all, params)

      expect(entry_query.filter.count).to eq(1)
    end

    it "filters the entries on to date" do
      entry.reload
      params = { to_date: entry2.created_at - 1.day }
      entry_query = EntryQuery.new(Entry.all, params)

      expect(entry_query.filter.count).to eq(1)
    end

    it "filters the entries on not billed" do
      entry2.reload
      params = { billed: entry.billed}
      entry_query = EntryQuery.new(Entry.all, params)

      expect(entry_query.filter.count).to eq(1)
    end
  end
end
