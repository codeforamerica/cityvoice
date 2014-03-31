FactoryGirl.define do
  factory :location do
    name { Faker::Address.street_address }
  end

  factory :subscriber do
    email { Faker::Internet.email }
  end

  factory :location_subscription do
    location
    subscriber

    trait :confirmed do
      confirmed true
    end

    trait :bulk_added do
      bulk_added true
    end
  end

  factory :answer do
    question { create :question, :voice }
    phone_number '000-555-1212'

    trait :with_voice_file do
      voice_file_url { Faker::Internet.http_url }
    end

    trait :with_location do
      location
    end
  end

  factory :voice_file do
    short_name { Faker::Name.name }
    url { "#{Faker::Internet.http_url}/#{short_name}" }
  end

  factory :question do
    short_name { Faker::Name.name }

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
