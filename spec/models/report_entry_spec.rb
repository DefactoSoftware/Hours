describe ReportEntry do
  let(:hour) { create(:hour_with_client) }
  let(:mileage) { create (:mileage_with_client) }
  subject(:report_entry) { ReportEntry.new(hour) }
  subject(:report_entry2) { ReportEntry.new(mileage) }

  it "#date localized" do
    expect(report_entry.date).to eq(I18n.l hour.date)
    expect(report_entry2.date).to eq(I18n.l mileage.date)
  end

  it "#user" do
    expect(report_entry.user).to eq(hour.user.name)
    expect(report_entry2.user).to eq(mileage.user.name)
  end

  it "#project" do
    expect(report_entry.project).to eq(hour.project.name)
    expect(report_entry2.project).to eq(mileage.project.name)
  end

  it "#category" do
    expect(report_entry.category).to eq(hour.category.name)
  end

  it "#client" do
    expect(report_entry.client).to eq(hour.project.client.name)
    expect(report_entry2.client).to eq(mileage.project.client.name)
  end

  it "#hours" do
    expect(report_entry.value).to eq(hour.value)
    expect(report_entry2.value).to eq(mileage.value)
  end

  it "#billable" do
    expect(report_entry.billable).to eq(hour.project.billable)
    expect(report_entry2.billable).to eq(mileage.project.billable)
  end

  it "#description" do
    expect(report_entry.description).to eq(hour.description)
  end

  it "#billable" do
    expect(report_entry.billed).to eq(hour.billed)
    expect(report_entry2.billed).to eq(mileage.billed)
  end
end
