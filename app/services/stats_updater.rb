# Calculates new project statistics based on contributions
class StatsUpdater
  def self.update(project)
    update_from_basic(project)
  rescue BasicStats::NoValues => e
    Rails.logger.error "Can't update project stats for #{project.slug}. #{e.message}"
  end

  def self.update_from_basic(project)
    stats = BasicStats.new project.contributions.map(&:commits).compact
    ProjectStats.find_or_create_by(project: project) do |ps|
      ps.update_attributes(
        weekly_commits_per_contributor_min: stats.min,
        weekly_commits_per_contributor_max: stats.max,
        weekly_commits_per_contributor_avg: stats.avg,
        weekly_commits_per_contributor_med: stats.med
      )
    end
  end
end
