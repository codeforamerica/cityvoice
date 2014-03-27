FactoryGirl.define do
  factory :property do
    name "1234 Fake St"

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
    question { create :question, :voice }

    trait :with_voice_file do
      voice_file_url { Faker::Internet.http_url }
    end
  end

  factory :voice_file do
    short_name { Faker::Name.first_name }
    url { "#{Faker::Internet.http_url}/#{short_name}" }
  end

  factory :question do
    short_name { Faker::Name.first_name }
    voice_file { create(:voice_file, short_name: short_name) }

    trait :number do
      feedback_type 'numerical_response'
    end

    trait :voice do
      feedback_type 'voice_file'
    end
  end

  factory :caller do
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
