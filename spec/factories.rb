FactoryGirl.define do
  factory :location do
    name { Faker::Address.street_address }
    description { Faker::Company.bs }
    lat { (SecureRandom.random_number * 180) - 90 }
    long { (SecureRandom.random_number * 360) - 180 }
  end

  factory :caller do
    phone_number { Faker::PhoneNumber.phone_number }
  end

  factory :call do
    location
    association :caller, factory: :caller
    source { Faker::PhoneNumber.phone_number }
    consented_to_callback { [true, false].sample }
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

  factory :answer do
    question { create :question, :voice }
    call

    trait :with_voice_file do
      voice_file_url { Faker::Internet.http_url }
    end

    trait :with_location do
      call { create(:call, :with_location) }
    end
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
end
