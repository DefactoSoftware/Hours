describe EntryStats do
  describe "user" do
    describe "#hours_spent_on" do
      it "calculates the total hours spent" do
        user = create(:user)
        project = create(:project)
        entry_with_hours_project_user(2, project, user)
        entry_with_hours_project_user(3, project, user)
        entry_with_hours_user(5, user)
        entry_stats = EntryStats.new(user.entries, project)
        expect(entry_stats.hours_spent_on).to eq(5)
      end
    end

    describe "#precentage_spent_on" do
      it "returns the percentage of hours spent" do
        user = create(:user)
        project1 = create(:project)
        project2 = create(:project)
        entry_with_hours_project_user(2, project1, user)
        entry_with_hours_project_user(2, project2, user)
        entry_stats = EntryStats.new(user.entries, project1)
        expect(entry_stats.percentage_spent_on).to eq(50)
      end
    end
  end
end