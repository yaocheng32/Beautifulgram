FactoryGirl.define do
  factory :post do
    sequence(:caption) { |n| "caption_#{n}" }
    association :user
    image Rack::Test::UploadedFile.new(Rails.root + 'spec/files/images/beach.jpg', 'image/jpg')

    factory :invalid_post do
      caption ''
      image nil
    end
  end
end
