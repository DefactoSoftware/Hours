# == Schema Information
#
# Table name: hours
#
#  id          :integer          not null, primary key
#  project_id  :integer          not null
#  category_id :integer          not null
#  user_id     :integer          not null
#  value       :integer          not null
#  date        :date             not null
#  created_at  :datetime
#  updated_at  :datetime
#  description :string
#  billed      :boolean          default("false")
#

describe Hour do
  describe "validations" do
    it { should validate_presence_of :user }
    it { should validate_presence_of :project }
    it { should validate_presence_of :category }
    it { should validate_presence_of :value }
    it { should validate_presence_of :date }
    it { should validate_numericality_of(:value).is_greater_than(0) }
    it { should validate_numericality_of(:value).only_integer }
  end

  describe "associations" do
    it { should belong_to :project }
    it { should belong_to :category }
    it { should belong_to :user }
    it { should have_many :taggings }
    it { should have_many :tags }
  end

  it "is audited" do
    hour = create(:hour)
    user = create(:user)

    Audited.audit_class.as_user(user) do
      hour.update_attribute(:value, 2)
    end

    expect(hour.audits.last.user).to eq(user)
  end

  describe "#tag_list" do
    it "returns a string of comma separated values" do
      hour = create(:hour, description: "#omg #hashtags")
      expect(hour.tag_list).to eq("omg, hashtags")
    end
  end

  describe "tags from the description" do
    let(:hour) { build(:hour) }

    it "parses the tags from the description" do
      hour.description = "Did some #opensource #scala, mostly for #research"
      hour.save
      expect(hour.tags.size).to eq(3)
      expect(hour.tag_list).to eq("opensource, scala, research")
    end

    it "removes any tagging that is left out" do
      hour.description = "#hashtags!"
      hour.save
      hour.description = "#omgomg"
      hour.save
      expect(hour.tag_list).to eq("omgomg")
    end

    it "updates the tag when the casing changes" do
      hour.description = "did some #tdd"
      hour.save
      expect {
        hour.description = "did some #TDD"
        hour.save
      }.to_not raise_error
      expect(Tag.last.name).to eq("TDD")
      expect(hour.reload.tag_list).to include("TDD")
    end
  end

  describe "#by_last_created_at" do
    it "orders the entries by created_at" do
      create(:hour)
      Timecop.scale(600)
      last_hour = create(:hour)
      expect(Hour.by_last_created_at.first).to eq(last_hour)
    end
  end

  describe "#by_date" do
    it "orders the entries by date (latest first)" do
      create(:hour, date: Date.new(2014, 01, 01))
      latest = create(:hour, date: Date.new(2014, 03, 03))
      create(:hour, date: Date.new(2014, 02, 02))

      expect(Hour.by_date.first).to eq(latest)
    end
  end

  it "#with_clients" do
    client = create(:client)
    create(:hour)
    create(:hour).project.update_attribute(:client, client)

    expect(Hour.with_clients.count).to eq(1)
  end

  describe "#query" do
    let(:entry_1) { create(:hour, date: 5.days.ago) }
    let(:entry_2) { create(:hour, date: 4.days.ago) }
    let(:entry_3) { create(:hour, date: 3.days.ago) }
    let(:entry_4) { create(:hour, date: 2.days.ago) }
    let(:entry_5) { create(:hour, date: 1.day.ago) }

    before(:each) do
      Timecop.freeze DateTime.new(2015, 4, 20)
      [entry_1, entry_2, entry_3, entry_4, entry_5]
    end

    it "queries by date" do
      entry_filter = {}
      entry_filter[:from_date] = "17/04/2015"
      entry_filter[:to_date] = "20/04/2015"
      entries = Hour.query(entry_filter)
      expect(entries).to include(entry_3, entry_4, entry_5)
    end
  end
end
