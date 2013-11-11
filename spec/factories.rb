FactoryGirl.define do
  factory :admin do
    sequence(:email) { |n| "admin#{n}@example.com" }
    password 'password'
    password_confirmation { |u| u.password }
  end

  factory :property do
    name "1234 Fake St"
    property_code "12345"
    parcel_id "111-2222-333"
  end
end
