FactoryGirl.define do
  factory :notification do
    association :user
    association :notified_by, factory: :user
    association :post
    identifier 1
    notice_type 'comment'
    read false
  end
end
