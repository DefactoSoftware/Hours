describe RemainingCategory do
  let(:project) { create(:project) }
  let(:category) { create(:category) }

  before(:each) do
    5.times do
      create(:hour, project: project)
    end
  end

  let(:remaining_category) do
    RemainingCategory.new(project.sorted_categories.drop(3))
  end

  it "has a gray name" do
    expect(remaining_category.name.pastel_color).to eq("#BEBEBE")
  end
end
