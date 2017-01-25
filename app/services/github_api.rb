require 'octokit'
require_relative 'github_api/search_repositories'

# Wrapper for github api
#
# Provides abstraction on top of Octokit to avoid directly depending on
# external interfaces.
class GithubApi
  class NotFound < StandardError; end

  def self.octokit
    raise 'Do not use in testing!' if ENV['RAILS_ENV'] == 'test'
    credentials = {
      client_id: ENV['GITHUB_DROS_CLIENT_ID'],
      client_secret: ENV['GITHUB_DROS_CLIENT_SECRET']
    }
    Octokit::Client.new(credentials)
  end

  def self.contributors_stats(slug)
    octokit.contributors_stats slug, retry_wait: 3, retry_timeout: 20
  end

  def self.repo(slug)
    octokit.repo(slug).to_h
  rescue Octokit::NotFound
    raise GithubApi::NotFound
  end

  def self.search_users(min_followers = 0)
    octokit.search_users("followers:>#{min_followers}").map(&:to_h)
  end

  def self.repositories(owner)
    octokit.repositories(owner).map(&:to_h)
  end

  # Returns enumerator containing repositories and total size
  #
  # Tries to fetch as many results with every request as possible (currently
  # 100 per page)
  def self.search_repositories(min_stars = 0)
    SearchRepositories.call(min_stars)
  end
end
