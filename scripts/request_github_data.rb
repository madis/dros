#!/usr/bin/env ruby

require 'bundler'
Bundler.setup

require 'octokit'

stats = Octokit.contributors_stats 'vuejs/vue'
output_filename = 'repo_stats_vuejs_vue.json'

File.open(output_filename, 'w') do |f|
  f.write JSON.pretty_generate(stats.map(&:to_h))
end

puts "Done writing stats to #{output_filename}"
