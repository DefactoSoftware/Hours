describe EntryStats do
  describe "projects" do
    let(:project) { create(:project) }

    describe "#total_hours" do
      context "with no entries" do
        it "returns 0" do
          entry_stats = EntryStats.new(project.hours)
          expect(entry_stats.total_hours).to eq(0)
        end
      end

      context "with entries" do
        it "returns the hours spent" do
          entry_with_hours_project(2, project)
          entry_with_hours_project(3, project)
          entry_stats = EntryStats.new(project.hours)
          expect(entry_stats.total_hours).to eq(5)
        end
      end

      context "with entries on multiple projects" do
        it "returns the hours spent" do
          entry = entry_with_hours_project(3, project)
          entry_with_hours_project(4, project)
          other_project = create(:project)
          entry_with_hours_project(3, other_project)
          entry_with_hours_project(2, other_project)
          entry_stats = EntryStats.new(project.hours, entry.category)
          expect(entry_stats.total_hours).to eq(7)
          expect(entry_stats.hours_for_subject).to eq(3)
          expect(entry_stats.percentage_for_subject).to eq(43)
        end
      end
    end

    describe "#percetange_spent_on(category)" do
      context "with entries in this category" do
        it "returns the percentage of hours spent" do
          category = create(:category)
          entry_with_hours_project_category(2, project, category)
          entry_with_hours_project(2, project)
          entry_stats = EntryStats.new(project.hours, category)
          expect(entry_stats.percentage_for_subject).to eq(50)
        end
      end
    end

    describe "#hours_for_subject_collection" do
      it "returns the hours spent per category" do
        user1 = create(:user)
        user2 = create(:user)
        entry_with_hours_project_user(4, project, user1)
        entry_with_hours_project_user(3, project, user2)
        entry_stats = EntryStats.new(project.hours)
        expect(entry_stats.hours_for_subject_collection(User.all)).to include(
          value: 4,
          color: user1.full_name.pastel_color,
          label: user1.full_name,
          highlight: "gray"
        )
        entry_stats = EntryStats.new(project.hours)
        expect(entry_stats.hours_for_subject_collection(User.all)).to include(
          value: 3,
          color: user2.full_name.pastel_color,
          label: user1.full_name,
          highlight: "gray"
        )
      end
    end
  end
end
