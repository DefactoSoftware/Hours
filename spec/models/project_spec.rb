# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#  client_id  :integer
#  billable   :boolean          default(FALSE)
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
    it { should belong_to :client }
  end

  describe "#label" do
    it "returns the projects name" do
      project = create(:project, name: "ProjectAwesome")
      expect(project.label).to eq("ProjectAwesome")
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

  describe "#title" do
    it "only shows name when there's no client" do
      project = create(:project)

      expect(project.title).to eq(project.name)
    end

    it "shows name and client when there's a client" do
      client = create(:client)
      project = create(:project, client: client)

      expect(project.title).to eq(project.name + " - " + client.name)
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
