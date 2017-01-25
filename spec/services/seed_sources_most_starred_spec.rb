require 'spec_helper'
require 'services/seed_sources'

describe SeedSources::MostStarred do
  it 'returns github most starred' do
    allow(GithubApi).to receive(:search_repositories).and_return json_fixture('most_starred_up_to_15000.json')
    most_starred = described_class.call
    expect(most_starred.count).to eq 161
    expect(most_starred).to all include :slug, :url
  end
end
