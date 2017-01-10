class ProjectStats < ApplicationRecord
  class GlobalStats
    attr_reader :weekly_commits_per_contributor_min
    attr_reader :weekly_commits_per_contributor_max
    attr_reader :weekly_commits_per_contributor_avg
    attr_reader :weekly_commits_per_contributor_med

    def initialize(min, max, avg, med)
      @weekly_commits_per_contributor_min = min
      @weekly_commits_per_contributor_max = max
      @weekly_commits_per_contributor_avg = avg
      @weekly_commits_per_contributor_med = med
    end
  end

  belongs_to :project

  # Uses median value for a column in every column to get global stats
  def self.global
    min = BasicStats.new(pluck(:weekly_commits_per_contributor_min)).med
    max = BasicStats.new(pluck(:weekly_commits_per_contributor_max)).med
    avg = BasicStats.new(pluck(:weekly_commits_per_contributor_avg)).med
    med = BasicStats.new(pluck(:weekly_commits_per_contributor_med)).med
    GlobalStats.new min, max, avg, med
  end
end
