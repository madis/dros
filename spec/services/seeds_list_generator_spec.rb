require 'spec_helper'
require 'services/seeds_list_generator'

describe SeedsListGenerator do
  it 'includes data from provided seed sources' do
    sources = [
      -> { example_seed 'madis/dros' },
      -> { example_seed 'rails/rails' }
    ]
    seeds = described_class.new(sources).generate
    expect(seeds.map).to include example_seed 'madis/dros'
    expect(seeds.map).to include example_seed 'rails/rails'
  end

  it 'does not contain duplicates' do
    source = -> { [example_seed('rails/rails')] }
    slugs = described_class.new([source, source]).generate.map { |x| x[:slug] }
    expect(slugs.uniq).to eq slugs
  end

  def example_seed(slug)
    {
      slug: slug,
      url: "https://github.com/#{slug}",
      created_at: Time.now.beginning_of_day
    }
  end
end
