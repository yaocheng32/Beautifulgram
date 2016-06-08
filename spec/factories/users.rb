FactoryGirl.define do
  factory :user do
    sequence(:user_name) { |n| "test_user#{n}" }
    sequence(:email) { |n| "test_user#{n}@gmail.com" }
    password 'password'

    factory :invalid_user do
      user_name ''
      email ''
      password ''
    end
  end
end
