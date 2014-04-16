# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#

require "spec_helper"

describe Project do
  let(:project) { create(:project) }

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
  end

  describe "associations" do
    it { should have_many :users }
    it { should have_many :categories }
    it { should have_many :entries }
    it { should have_many :tags }
  end

  describe "#hours_spent" do
    context "with no entries" do
      it "returns 0" do
        expect(project.hours_spent).to eq(0)
      end
    end

    context "with entries" do
      it "returns the hours spent" do
        create(:entry, hours: 2, project: project)
        create(:entry, hours: 3, project: project)
        expect(project.hours_spent).to eq(5)
      end
    end

    context "with entries on multiple projects" do
      it "returns the hours spent" do
        entry = create(:entry, hours: 3, project: project)
        create(:entry, hours: 4, project: project)
        other_project = create(:project)
        create(:entry, hours: 3, project: other_project)
        create(:entry, hours: 2, project: other_project)
        expect(project.hours_spent).to eq(7)
        expect(entry.category.hours_spent(project)).to eq(3)
        expect(entry.category.percentage_spent_on(project)).to eq(43)
      end
    end
  end

  describe "#percetange_spent_on(category)" do
    context "with entries in this category" do
      it "returns the percentage of hours spent" do
        category = create(:category)
        create(:entry, hours: 2, project: project, category: category)
        create(:entry, hours: 2, project: project, category: create(:category))
        expect(category.percentage_spent_on(project)).to eq(50)
      end
    end
  end

  describe "#hours_per_user" do
    it "returns the hours spent per category" do
      user1 = create(:user)
      user2 = create(:user)
      create(:entry, hours: 4, project: project, user: user1)
      create(:entry, hours: 3, project: project, user: user2)
      expect(project.hours_per_user).to include(
        value: 4, color: user1.full_name.pastel_color
      )
      expect(project.hours_per_user).to include(
        value: 3, color: user2.full_name.pastel_color
      )
    end
  end

  describe "#by_last_updated" do
    it "orders the projects by last updated first" do
      create(:project)
      project = create(:project)
      create(:project)
      project.touch

      expect(Project.by_last_updated.first).to eq(project)
    end
  end

  describe "#by_name" do
    it "orders by name case insensitive" do
      create(:project, name: "B")
      a = create(:project, name: "a")
      expect(Project.by_name.first).to eq(a)
    end
  end
end
