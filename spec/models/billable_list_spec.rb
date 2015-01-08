require "spec_helper"

describe BillableList do
  let(:client1) { create(:client) }
  let(:client2) { create(:client) }
  let(:project1) { create(:project, client: client1) }
  let(:project2) { create(:project, client: client2, billable: true) }

  let!(:entry1) { create(:entry, project: project1) }
  let!(:entry2) { create(:entry, project: project2) }
  let!(:entry3) { create(:entry) }

  let(:billable_list) { BillableList.new(Entry.billable) }

  it "has a list of clients" do
    expect(billable_list.clients.count).to eq(1)
  end

  it "has a list of projects" do
    expect(billable_list.projects_for_client(client2).count).to eq(1)
    expect(billable_list.projects_for_client(client1).count).to eq(0)
  end

  it "has entries for a project" do
    expect(billable_list.entries_for_project(project1).count).to eq(0)
    expect(billable_list.entries_for_project(project2).count).to eq(1)
  end
end
