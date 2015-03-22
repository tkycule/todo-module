FactoryGirl.define do
  factory :task do
    association :user
    sequence(:title) {|n| "Task #{n}"}

    factory :invalid_task do
      title nil
    end
  end
end
