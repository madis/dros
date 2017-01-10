require_relative '../models/basic_stats'

# Calculates relative health for project compared to others projects
class HealthDiagnosis
  def initialize(project_stats, global_stats)
    @project_stats = project_stats
    @global_stats = global_stats
  end

  def health
    percent = (p.weekly_commits_per_contributor_med.to_f / g.weekly_commits_per_contributor_med) * 100
    within_bounds(percent)
  end

  private

  def within_bounds(percent)
    if percent > 100
      100
    else
      percent
    end
  end

  def g
    @global_stats
  end

  def p
    @project_stats
  end
end
