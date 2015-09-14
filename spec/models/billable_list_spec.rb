describe BillableList do
  let(:client1) { create(:client) }
  let(:client2) { create(:client) }
  let(:client3) { create(:client) }

  let(:project1) { create(:project, client: client1) }
  let(:project2) { create(:project, client: client2, billable: true) }
  let(:project3) { create(:project, client: client3, billable: true) }

  let!(:entry1) { create(:hour, project: project1) }
  let!(:entry2) { create(:hour, project: project2) }
  let!(:entry3) { create(:mileage, project: project3) }

  let(:billable_list) { BillableList.new(Hour.billable, Mileage.billable) }

  it "has a list of clients" do
    expect(billable_list.clients.count).to eq(2)
  end
end
