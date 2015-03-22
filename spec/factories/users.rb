FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "test#{n}@example.com"}
    password "password"
    password_confirmation "password"

    factory :invalid_user do
      email nil
    end
  end
end
