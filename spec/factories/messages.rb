# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :message do
    title "MyString"
    name "MyString"
    email "MyString"
    body "MyText"
  end
end
