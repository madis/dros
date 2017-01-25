require_relative 'seed_sources'

# Goes over different seed sources and generates a list of repositories
# that could be imported for health measurement so that the system has some
# data available immediately
class SeedsListGenerator
  SOURCES = [
    SeedSources::Trending,
    SeedSources::MostStarred,
    SeedSources::MostFollowed
  ].freeze

  def self.generate
    new(SOURCES).generate
  end

  def initialize(sources)
    @sources = sources
  end

  def generate
    sources.flat_map(&:call).uniq { |r| r[:slug] }
  end

  private

  attr_reader :sources
end
