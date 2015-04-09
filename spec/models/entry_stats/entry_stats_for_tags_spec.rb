describe EntryStats do
  describe "tags" do
    let(:tag) { create(:tag) }
    let(:project) { create(:project) }
    let(:user) { create(:user) }

    describe "#hours_for" do
      context "with no entries" do
        it "returns 0" do
          entry_stats = EntryStats.new(tag.hours, project)
          expect(entry_stats.hours_for_subject).to eq(0)
        end
      end

      context "with entries" do
        it "returns the hours spent" do
          entry_with_hours_project_tag(2, project, tag)
          entry_with_hours_project_tag(3, project, tag)
          entry_stats = EntryStats.new(tag.hours, project)
          expect(entry_stats.hours_for_subject).to eq(5)
        end
      end
    end

    describe "#percentage_for_subject_user" do
      context "with entries with this user" do
        it "returns the percentage of hours spent" do
          entry_with_hours_project_tag_user(3, project, tag, user)
          entry_with_hours_project_tag(3, project, tag)
          entry_stats = EntryStats.new(tag.hours, user)
          expect(entry_stats.percentage_for_subject).to eq(50)
        end
      end
    end

    describe "#percentage_for_subject_project" do
      context "with entries in this project" do
        it "returns the percentage of hours spent" do
          entry_with_hours_project_tag(2, project, tag)
          entry_with_hours_tag(2, tag)
          entry_stats = EntryStats.new(tag.hours, project)
          expect(entry_stats.percentage_for_subject).to eq(50)
        end
      end
    end

    describe "#total_hours" do
      let(:entry_stats) { EntryStats.new(tag.hours) }
      context "with no entries" do
        it "returns 0" do
          expect(entry_stats.total_hours).to eq(0)
        end
      end

      context "with entries tagged" do
        it "returns the hours spent" do
          entry_with_hours_tag(2, tag)
          entry_with_hours_tag(3, tag)
          expect(entry_stats.total_hours).to eq(5)
        end
      end

      context "with only part of entries tagged" do
        it "returns the hours spent" do
          entry_with_hours_tag(3, tag)
          entry_with_hours_tag(4, tag)
          entry_with_hours(3)
          entry_with_hours(2)
          expect(entry_stats.total_hours).to eq(7)
        end
      end
    end
  end
end
