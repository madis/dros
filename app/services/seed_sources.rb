require_relative 'github_trending'
require_relative 'github_api'

# Collection of different sources for repositories for using
# as seeds and example data
class SeedSources
  # List of trending repos
  class Trending
    LANGUAGES = ['ruby', 'javascript', ''].freeze
    PERIODS = %i(today weekly monthly).freeze

    def self.call
      new.call
    end

    def call
      add_origin trending_language_repos_of_different_periods
    end

    private

    def trending_language_repos_of_different_periods
      LANGUAGES.product(PERIODS).map(&method(:fetch_trending)).flatten.compact
    end

    def fetch_trending(language_period)
      language, period = language_period
      GithubTrending.public_send(period, language: language)
    end

    def add_origin(collection)
      collection.map { |s| s.merge source_description: 'From GithubTrending' }
    end
  end

  # List of most starred repositories
  class MostStarred
    MIN_STARS = 4000

    def self.call
      GithubApi.search_repositories(MIN_STARS).map do |repo|
        {
          slug: repo[:full_name],
          url: repo[:html_url]
        }
      end
    end
  end

  # Finds interesting repositories of most followed users
  class MostFollowed
    MIN_FOLLOWERS = 5000

    def self.call
      GithubApi.search_users(MIN_FOLLOWERS).flat_map do |user|
        repos = GithubApi.repositories(user[:login]).sort_by do |repo|
          repo[:stargazers_count]
        end.reverse.take(10)
        repos.map do |repo|
          { slug: repo[:full_name], url: repo[:html_url] }
        end
      end
    end
  end
end
