FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Test title#{n}" }
    status { 0 }
    association :user
  end
end
