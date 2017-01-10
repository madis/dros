#!/usr/bin/env ruby

require_relative '../app/services/github_trending'
require_relative '../app/services/github_api'
require 'fileutils'

timestamp = Time.now.strftime('%Y-%m-%d_%H%M%S')
base_path = "tmp/imports/#{timestamp}"
puts "Will be storing imports under #{base_path}"
FileUtils.mkdir_p base_path

raw_trending = [
  GithubTrending.today,
  GithubTrending.weekly,
  GithubTrending.monthly,
  GithubTrending.today(language: 'ruby'),
  GithubTrending.weekly(language: 'ruby'),
  GithubTrending.monthly(language: 'ruby'),
  GithubTrending.today(language: 'javascript'),
  GithubTrending.weekly(language: 'javascript'),
  GithubTrending.monthly(language: 'javascript')
].flatten
puts "Received #{raw_trending.count} trending repos"
puts 'Removing duplicates'

unique_trending = raw_trending.uniq { |r| r[:slug] }

puts "Importing data for #{unique_trending.count} repos", unique_trending

def retryable(tries:)
  retry_count = 0
  until retry_count > tries
    print "Try nr #{retry_count}."
    result = yield
    if !result.nil?
      print " Got non-nil result. returning\n"
      return result
    else
      print ' Got nil. Retrying after 2s'
      sleep 2
      retry_count += 1
    end
  end
end

unique_trending.each.with_index do |repo, index|
  puts "#{index} Requesting contributors_stats for #{repo}"
  stats = retryable(tries: 3) { GithubApi.contributors_stats repo[:slug] }
  source = 'trending'
  period = repo[:period]
  stat_type = 'contributors_stats'
  file_name_slug = repo[:slug].sub('/', '_')
  file_basename = "#{base_path}/#{source}-#{period}-#{stat_type}-#{file_name_slug}"
  stats_hash = stats.map(&:to_h)
  meta_hash = repo.merge(created_at: Time.now)
  File.open("#{file_basename}.json", 'w') { |f| f.write(JSON.pretty_generate(stats_hash)) }
  File.open("#{file_basename}-meta.json", 'w') { |f| f.write(JSON.pretty_generate(meta_hash)) }
  puts "Done #{repo[:slug]}. Writing to #{file_basename}"
end
