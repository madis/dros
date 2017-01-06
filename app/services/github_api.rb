# Wrapper for github api
#
# Provides abstraction on top of Octokit to avoid directly depending on
# external interfaces.
class GithubApi
  def self.contributors_stats(slug)
    raise 'Do not use in testing!' if ENV['RAILS_ENV'] == 'test'
    Octokit.contributors_stats slug
  end
end
