FactoryGirl.define do
  factory :post do
    association :user, factory: :user
    sequence(:title) {|n| "#{Faker::Hacker.say_something_smart}-#{n}"}
    sequence(:body) {|n| "#{Faker::Lorem.paragraph}-#{n}"}
  end
end
