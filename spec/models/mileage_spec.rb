# == Schema Information
#
# Table name: mileages
#
#  id         :integer          not null, primary key
#  project_id :integer          not null
#  user_id    :integer          not null
#  value      :integer          not null
#  date       :date             not null
#  billed     :boolean          default("false")
#  created_at :datetime
#  updated_at :datetime
#

describe Mileage do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :project }
    it { should validate_presence_of :value }
    it { should validate_presence_of :date }
    it { should validate_numericality_of(:value).is_greater_than(0) }
    it { should validate_numericality_of(:value).only_integer }
  end

  describe "associations" do
    it { should belong_to :user }
    it { should belong_to :project }
  end

  it "is audited" do
    mileage = create(:mileage)
    user = create(:user)

    Audited.audit_class.as_user(user) do
      mileage.update_attribute(:value, 2)
    end
    expect(mileage.audits.last.user).to eq(user)
  end

  describe "#by_last_created_at" do
    it "orders the entries by created_at" do
      create(:mileage)
      Timecop.scale(600)
      last_hour = create(:mileage)
      expect(Mileage.by_last_created_at.first).to eq(last_hour)
    end
  end

  describe "by_date" do
    it "orders the entries by date (latest first)" do
      create(:mileage, date: Date.new(2014, 01, 01))
      latest = create(:mileage, date: Date.new(2014, 03, 03))
      create(:mileage, date: Date.new(2014, 02, 02))

      expect(Mileage.by_date.first).to eq(latest)
    end

    it "#with_clients" do
      client = create(:client)
      create(:mileage)
      create(:mileage).project.update_attribute(:client, client)

      expect(Mileage.with_clients.count).to eq(1)
    end
  end
end
