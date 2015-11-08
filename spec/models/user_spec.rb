# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string           default(""), not null
#  last_name              :string           default(""), not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default("0"), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime
#  updated_at             :datetime
#  organization_id        :integer
#  slug                   :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default("0")
#

describe User do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :slug }
    it { should validate_uniqueness_of :slug }
  end

  describe "associations" do
    it { should have_one :account }
    it { should belong_to :organization }
    it { should have_many :hours }
    it { should have_many :mileages }
  end

  describe "#label" do
    it "returns the users full name" do
      user = create(:user, first_name: "Karel", last_name: "Appel")
      expect(user.label).to eq("Karel Appel")
    end
  end

  describe "#full_name" do
    it "returns the users full name" do
      user = create(:user, first_name: "John", last_name: "Doe")
      expect(user.full_name).to eq("John Doe")
    end
  end

  describe "generating unique slugs" do
    it "uses the full name when available" do
      user = create(:user, first_name: "Phillip", last_name: "Fry")
      expect(user.slug).to eq("phillip-fry")
    end

    it "uses the full name with an index when the full name is taken" do
      create(:user, first_name: "Phillip", last_name: "Fry")
      user_with_same_name = create(:user, first_name: "Phillip", last_name: "Fry")
      expect(user_with_same_name.slug).to eq("phillip-fry-1")
    end
  end

  describe "#email_domain" do
    it "returns the users email domain" do
      user = build(:user, email: "test@example.com")
      expect(user.email_domain).to eq("example.com")
    end
  end
end
