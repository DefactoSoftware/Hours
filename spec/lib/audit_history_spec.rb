require "audit_history"

describe AuditHistory do
end

describe AuditChange do
  context "with associations" do
    let(:change) { ["project_id", [3, 4]] }
    let(:audit_change) { AuditChange::Update.new(change) }
    let(:project) { double(:project) }

    it "#from" do
      allow(Project).to receive(:find).with(3) { project }

      expect(audit_change.from).to eq(project)
    end

    it "#to" do
      allow(Project).to receive(:find).with(4) { project }

      expect(audit_change.to).to eq(project)
    end

    it "#property" do
      expect(audit_change.property).to eq("project")
    end

    it "#destroyed?" do
      # Project.find(3) does not exist
      expect(audit_change.from.destroyed?).to eq(true)
    end
  end

  context "remove association" do
    let(:change) { ["client_id", [1,nil]] }
    let(:audit_change) { AuditChange::Update.new(change) }

    it "to_string" do
      expect(audit_change.to.to_s).to eq("nothing")
    end

    it "#destroyed?" do
      expect(audit_change.to.destroyed?).to eq(true)
    end
  end

  context "with values" do
    let(:change) { ["description", ["Foo", "Bar"]] }
    let(:audit_change) { AuditChange::Update.new(change) }

    it "#from" do
      expect(audit_change.from).to eq("Foo")
    end

    it "#to" do
      expect(audit_change.to).to eq("Bar")
    end

    it "#property" do
      expect(audit_change.property).to eq("description")
    end
  end
end
