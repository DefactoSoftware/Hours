require "spec_helper"

describe EntryQuery do
  let(:client) { create(:client) }
  let(:project) { create(:project, archived: true, client: client) }
  let!(:entry) { create(:entry, billed: false, project: project, created_at: 20.days.ago) }
  let!(:entry2) { create(:entry, billed: true, created_at: 10.days.ago) }
  let(:params) { {} }

  describe "#filter" do
    it "filters the entries on project id" do
      expect(filter({ project_id: entry.project.id }).count).to eq(1)
    end

    it "filters the entries on client_id" do
      expect(filter({ client_id: entry.client.id }).count).to eq(1)
    end

    it "filters the entries on from_date" do
      expect(filter({ from_date: entry.created_at + 1.day }).count).to eq(1)
    end

    it "filters the entries on to date" do
      expect(filter({ to_date: entry2.created_at - 1.day }).count).to eq(1)
    end

    it "filters the entries on not billed" do
      expect(filter({ billed: entry.billed}).count).to eq(1)
    end

    it "filters the entries on archived" do
      expect(filter({ archived: true }).count).to eq(1)
    end

    it "filters on all params" do
      expect(filter(
        {
          billed: entry.billed,
          to_date: entry2.created_at + 1.day,
          from_date: entry.created_at - 1.day,
          client_id: entry.client.id,
          project_id: entry.project.id
        }
      ).count).to eq(1)
    end

    def filter(params)
      EntryQuery.new(Entry.all, params).filter
    end
  end
end
