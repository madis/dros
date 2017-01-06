#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'octokit'

owner = 'rails'
repo = 'rails'
stats = Octokit.contributors_stats "#{owner}/#{repo}"
output_filename = "repo_stats_#{owner}_#{repo}.json"

sleep 3

File.open(output_filename, 'w') do |f|
  f.write JSON.pretty_generate(stats.map(&:to_h))
end

puts "Done writing stats to #{output_filename}"
