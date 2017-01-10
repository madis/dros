FactoryGirl.define do
  factory :project do
    owner 'rails'
    repo 'rails'

    trait :up_to_date do
      after(:create) { |p| create(:data_request, :completed, slug: p.slug) }
    end
  end

  factory :contribution do
  end

  factory :data_request do
    trait :completed do
      status :completed
      updated_at Time.now
    end
  end
end
