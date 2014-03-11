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

  factory :notification_subscription do
    email { Faker::Internet.email }
    property

    trait :confirmed do
      confirmed true
    end

    trait :bulk_added do
      bulk_added true
    end
  end

  factory :feedback_input do
    question

    trait :with_voice_file do
      voice_file_url { Faker::Internet.http_url }
    end
  end

  factory :question do
    voice_text { Faker::Company.bs }
    short_name { Faker::Name.first_name }
    feedback_type { %w(numerical_response voice_file).sample }
  end

  factory :voice_file do
    short_name { Faker::Name.first_name }
    url { Faker::Internet.http_url }
  end

  factory :caller do
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
