# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence :email do |n| 
      "email#{n}@example.com"
    end
    password "password"

    factory :user_with_auth do
      after(:create) do |user, evaluator|
        providers = FactoryGirl.create_list(:provider, 5)
        providers.each do |p|
          FactoryGirl.create(:authentication, :user => user, :provider => p)
        end
      end
    end

  end
end
