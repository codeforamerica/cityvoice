FactoryGirl.define do
  factory :property do
    name "1234 Fake St"
    property_code "12345"
    parcel_id "111-2222-333"

    factory :property_with_info_set do
      after(:create) do |property|
        FactoryGirl.create(:property_info_set, property_id: property.id)
      end
    end
  end

  factory :property_info_set do
    outcome "Vacant and Abandoned"
    demo_order "Affirmed"
  end
end
