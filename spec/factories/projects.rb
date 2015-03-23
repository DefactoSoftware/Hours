FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "project#{n}" }
    billable false
    archived false

    factory :project_with_hours do
      after(:create) do |project, _evaluator|
        create_list(:hour, 2, project: project)
      end
    end

    factory :project_with_more_than_maximum_hours do
      after(:create) do |project, _evaluator|
        create_list(:hour, 7, project: project)
      end
    end
  end
end
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

# Read about factories at https://github.com/thoughtbot/factory_girl
