FactoryGirl.define do
  factory :comment do
    association :post
    association :user
    sequence(:content) { |n| "comment content #{n}" }

    factory :invalid_comment do
      content ''
    end
  end
end
