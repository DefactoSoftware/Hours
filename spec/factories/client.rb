FactoryGirl.define do
  factory :client do
    sequence(:name) { |n| "client#{n}" }
    description "this is a description"
  end
end
