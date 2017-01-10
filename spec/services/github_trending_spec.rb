require 'spec_helper'
require 'services/github_trending'

describe GithubTrending do
  describe '#find' do
    it 'requests language and period' do
      endpoint = stub_request(:get, 'https://github.com/trending/ruby?since=weekly')
                 .to_return(status: 200, body: fixture('trending_today.html'))

      described_class.new(period: 'weekly', language: 'ruby').find

      expect(endpoint).to have_been_requested
    end

    it 'extracts data from html' do
      stub_request(:get, 'https://github.com/trending/?since=today')
        .to_return(status: 200, body: fixture('trending_today.html'))

      trending = described_class.new(period: 'today').find

      expect(trending.count).to eq 25
      expect(trending.first).to eq(
        slug: 'ryanmcdermott/clean-code-javascript',
        stars: 675,
        language: 'javascript',
        period: 'today'
      )
    end
  end

  shared_examples 'class convenience method' do |method|
    it 'passes params to new and calls find' do
      trending_instance = double('GithubTrending', find: true)
      allow(described_class).to receive(:new).and_return(trending_instance)
      described_class.public_send(method, language: 'ruby')
      expect(described_class).to have_received(:new).with(period: method.to_s, language: 'ruby')
      expect(trending_instance).to have_received(:find)
    end
  end

  describe '.today' do
    it_behaves_like 'class convenience method', :today
  end

  describe '.weekly' do
    it_behaves_like 'class convenience method', :weekly
  end

  describe '.monthly' do
    it_behaves_like 'class convenience method', :monthly
  end
end
