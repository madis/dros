require_relative '../models/basic_stats'

# Calculates relative health for project compared to others projects
class HealthDiagnosis
  def initialize(project_stats, global_stats)
    @project_stats = project_stats
    @global_stats = global_stats
  end

  def health
    100
  end
end
