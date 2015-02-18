describe EntryStats do
  describe "categories" do
    describe "#hours spent" do
      it "returns the hours spent" do
        entry = entry_with_hours(2)
        entry_stats = EntryStats.new(entry.category.hours)
        expect(entry_stats.total_hours).to eq(2)
      end
    end

    describe "#percentage spent" do
      it "returns the percentage spent" do
        project = create(:project)
        entry = entry_with_hours_project(2, project)
        entry_with_hours_project(3, project)
        entry_stats = EntryStats.new(entry.project.hours, entry.category)
        expect(entry_stats.percentage_for_subject).to eq(40)
      end
    end
  end
end
