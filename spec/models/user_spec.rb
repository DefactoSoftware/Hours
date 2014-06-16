# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  first_name             :string(255)      default(""), not null
#  last_name              :string(255)      default(""), not null
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  organization_id        :integer
#

require "spec_helper"

describe User do
  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :slug }
    it { should validate_uniqueness_of :slug }

    describe "email domain" do
      let(:subdomain) { generate(:subdomain) }
      let(:owner) { build(:user, email: "admin@defacto.nl") }
      let(:account) { create(:account_with_schema, owner: owner, subdomain: subdomain) }

      it "is not valid if the email domain is different from the account owner" do
        user = build(:user, email: "admin@example.com", organization: account)
        expect(user).to_not be_valid
        expect(user.errors[:email]).to include("Email does not match organization email")
      end

      it "is not valid if the email domain is different from the account owner" do
        user = build(:user, email: "test@defacto.nl", organization: account)
        expect(user).to be_valid
      end
    end
  end

  describe "associations" do
    it { should have_one :account }
    it { should belong_to :organization }
    it { should have_many :entries }
  end

  describe "#full_name" do
    it "returns the users full name" do
      user = create(:user, first_name: "John", last_name: "Doe")
      expect(user.full_name).to eq("John Doe")
    end
  end

  describe "#hours_spent_on" do
    it "calculates the total hours spent" do
      user = create(:user)
      project = create(:project)
      create(:entry, hours: 2, user: user, project: project)
      create(:entry, hours: 3, user: user, project: project)
      create(:entry, hours: 5, user: user)
      expect(user.hours_spent_on(project)).to eq(5)
    end
  end

  describe "#precentage_spent_on" do
    it "returns the percentage of hours spent" do
      user = create(:user)
      project1 = create(:project)
      project2 = create(:project)
      create(:entry, user: user, project: project1, hours: 2)
      create(:entry, user: user, project: project2, hours: 2)
      expect(user.percentage_spent_on(project1)).to eq(50)
    end
  end

  describe 'generating unique slugs' do
    it "uses the full name when available" do
      user = create(:user, first_name: 'Phillip', last_name: 'Fry')
      expect(user.slug).to eq('phillip-fry')
    end

    it "uses the full name with an index when the full name is taken" do
      create(:user, first_name: 'Phillip', last_name: 'Fry')
      user_with_same_name = create(:user, first_name: 'Phillip', last_name: 'Fry')
      expect(user_with_same_name.slug).to eq('phillip-fry-1')
    end
  end
end
