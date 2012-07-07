# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :authentication do
    provider_id 1
    uid         "8532453"
    token       "af22aacd2da2ea2da"
    secret      "asdfcaac21344ea2da"
  end
end
