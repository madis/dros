require 'octokit'

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
end
