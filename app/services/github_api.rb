require 'octokit'
require_relative 'github_api/search_repositories'
require_relative 'response_store'

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
    response = octokit.contributors_stats slug, retry_wait: 3, retry_timeout: 20
    ResponseStore.store data: response, args: slug
    response
  end

  def self.repo(slug)
    response = octokit.repo(slug).to_h
    ResponseStore.store data: response, args: slug
    response
  rescue Octokit::NotFound
    raise GithubApi::NotFound
  end

  def self.search_users(min_followers = 0)
    response = octokit.search_users("followers:>#{min_followers}")[:items].map(&:to_h)
    ResponseStore.store data: response, args: min_followers
    response
  end

  def self.repositories(owner)
    response = octokit.repositories(owner).map(&:to_h)
    ResponseStore.store data: response, args: owner
    response
  end

  # Returns enumerator containing repositories and total size
  #
  # Tries to fetch as many results with every request as possible (currently
  # 100 per page)
  def self.search_repositories(min_stars = 0)
    response = SearchRepositories.call(min_stars)
    ResponseStore.store data: response, args: min_stars
    response
  end
end
