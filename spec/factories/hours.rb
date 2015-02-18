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

FactoryGirl.define do
  factory :hour do
    project
    category
    description ""
    value 1
    date "2014-02-26"
    user

    factory :hour_with_client do
      project { create(:project, client: create(:client)) }
    end
  end
end
