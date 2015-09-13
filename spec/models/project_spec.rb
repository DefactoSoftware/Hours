# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string           default(""), not null
#  created_at  :datetime
#  updated_at  :datetime
#  slug        :string
#  budget      :integer
#  billable    :boolean          default("false")
#  client_id   :integer
#  archived    :boolean          default("false"), not null
#  description :text
#

describe Project do
  let(:project) { create(:project) }

  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }

    it "is not valid with billable true and no client" do
      project = Project.new(name: "test", billable: true, client: nil)
      expect(project).to_not be_valid
    end

    it "is valid with a client and billable true" do
      project = Project.new(name: "test", billable: true, client: build_stubbed(:client))
      expect(project).to be_valid
    end
  end

  describe "associations" do
    it { should have_many :users }
    it { should have_many :categories }
    it { should have_many :hours }
    it { should have_many :mileages }
    it { should have_many :tags }
    it { should belong_to :client }
  end

  it "is audited" do
    project = create(:project, name: "ProjectAwesome")
    user = create(:user)

    Audited.audit_class.as_user(user) do
      project.update_attribute(:archived, true)
    end

    expect(project.audits.last.user).to eq(user)
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
      Timecop.scale(600)
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

  describe "#budget" do
    it "can have a budget" do
      project = create(:project, budget: 11)
      create(:hour, value: 3, project: project)
      create(:hour, value: 2, project: project)
      expect(project.budget_status).to eq(6)
    end
  end
end
