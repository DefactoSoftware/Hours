FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| "project#{n}" }
    billable false
    archived false

    factory :project_with_entries do
      after(:create) do |project, evaluator|
        create_list(:entry, 2, project: project)
      end
    end

    factory :project_with_more_than_maximum_entries do
      after(:create) do |project, evaluator|
        create_list(:entry, 7, project: project)
      end
    end
  end
end

# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime
#  updated_at :datetime
#  slug       :string(255)
#  billable   :boolean          default(FALSE)
#  archived   :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

