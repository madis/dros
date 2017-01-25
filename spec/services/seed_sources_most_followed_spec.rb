require 'spec_helper'
require 'services/seed_sources'

describe SeedSources::MostFollowed do
  it 'gets up to 10 most popular repositories of very followed user' do
    allow(GithubApi).to receive(:search_users).and_return json_fixture('most_followed_up_to_5000.json').take 2
    allow(GithubApi).to receive(:repositories).and_return json_fixture('osmani_popular_25_repos.json')

    most_followed = described_class.call

    expect(most_followed.count).to eq 20
    expect(most_followed.first).to eq(
      url: 'https://github.com/addyosmani/backbone-fundamentals',
      slug: 'addyosmani/backbone-fundamentals'
    )
  end
end
