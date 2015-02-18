describe EntryStats do
  describe "remainingCategory" do
    describe "#hours_for_subject" do
      it "calculates the total hours spent" do
        project = create(:project)
        category1 = create(:category)
        category2 = create(:category)
        entry_with_hours_project_category(2, project, category1)
        entry_with_hours_project_category(2, project, category2)
        remaining_category = RemainingCategory.new([category1, category2])
        entry_stats = EntryStats.new(project.hours, remaining_category)
        expect(entry_stats.hours_for_subject).to eq(4)
      end
    end

    describe "#precentage_spent_on" do
      it "returns the percentage of hours spent" do
        project1 = create(:project)
        category1 = create(:category)
        category2 = create(:category)
        category3 = create(:category)
        entry_with_hours_project_category(2, project1, category1)
        entry_with_hours_project_category(2, project1, category2)
        entry_with_hours_project_category(4, project1, category3)
        remaining_category = RemainingCategory.new([category1, category2])
        entry_stats = EntryStats.new(project1.hours, remaining_category)
        expect(entry_stats.percentage_for_subject).to eq(50)
      end
    end
  end
end
