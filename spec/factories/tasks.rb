FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "Test title#{n}" }
    status { :todo }
    deadline { 1.week.from_now }
    association :user
  end
end
