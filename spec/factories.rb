FactoryGirl.define do
  factory :project do
    owner 'rails'
    repo 'rails'

    trait :up_to_date do
      after(:create) { |p| create(:data_request, :completed, slug: p.slug) }
    end
  end

  factory :contribution do
    sequence(:author) { |n| "john-doe-#{n}" }
    sequence(:week) { |n| 1.year.ago.beginning_of_week + n * 1.week }
    additions 0
    deletions 0
    commits 0
  end

  factory :data_request do
    trait :completed do
      status :completed
      updated_at Time.now
    end
  end
end
