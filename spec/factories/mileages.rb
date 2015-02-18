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

FactoryGirl.define do
  factory :mileage do
    project
    value 1
    date "2014-02-26 22:06:47"
    user

    factory :mileage_with_client do
      project { create(:project, client: create(:client)) }
    end
  end
end
