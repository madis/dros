require 'spec_helper'
require 'services/seed_sources'

describe SeedSources::Trending do
  let(:example_seed) do
    {
      slug: 'madis/dros',
      url: 'https://github.com/madis/dros',
      created_at: '2017-01-23'
    }
  end

  it 'lists repos from github trending' do
    allow(GithubTrending).to receive(:today).and_return [example_seed]
    allow(GithubTrending).to receive(:weekly).and_return [example_seed]
    allow(GithubTrending).to receive(:monthly).and_return [example_seed]

    generated_seeds = described_class.call
    expect(generated_seeds).to all include(example_seed.except(:source_description))
    described_class::LANGUAGES.each do |lang|
      expect(GithubTrending).to have_received(:today).with language: lang
      expect(GithubTrending).to have_received(:weekly).with language: lang
      expect(GithubTrending).to have_received(:monthly).with language: lang
    end
    expect(generated_seeds.first).to include source_description: 'From GithubTrending'
  end
end
