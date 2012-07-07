# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :provider do
    sequence :name do |n|
      "provider#{n}"
    end
  end
end
