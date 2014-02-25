# == Schema Information
#
# Table name: accounts
#
#  id         :integer          not null, primary key
#  subdomain  :string(255)      default(""), not null
#  owner_id   :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:subdomain) { |n| "subdomain#{n}" }

  factory :account do
    sequence(:subdomain) { |n| "subdomain#{n}" }
    association :owner, factory: :user

    factory :account_with_schema do
      after(:build) do |account|
        Apartment::Database.create(account.subdomain)
        Apartment::Database.switch(account.subdomain)
      end
      after(:create) do
        Apartment::Database.reset
      end
    end
  end
end
