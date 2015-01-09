FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "item name #{n}" }
    price 1000
    description 'item description'
  end
end
