# Takes care of importing project data from external sources and updating
# necessary models in database
class Importer
  def self.import(project)
    new(project).import
  end

  def initialize(project)
    @project = project
  end

  def import
    stats = GithubApi.contributors_stats @project.slug
    update_contributions(stats)
    update_health
  end

  private

  CONTRIBUTION_COLUMNS = %i(project_id author week additions deletions commits created_at updated_at).freeze

  attr_reader :project

  def update_contributions(stats)
    data_columns = [:a, :d, :c]
    Contribution.bulk_insert(*CONTRIBUTION_COLUMNS) do |worker|
      stats.each do |stat_row|
        stat_row[:weeks].each do |week|
          data_values = week.values_at(*data_columns)
          next if data_values.all?(&:zero?)
          worker.add [project.id, stat_row[:author][:login], week[:w], *data_values]
        end
      end
    end
  end

  def update_health
    project.health = health_based_on_contribution_activity
    project.save
  end

  def health_based_on_contribution_activity
    contributions_last_week = project.contributions(week: 1.week.ago..Time.now)
    case contributions_last_week
    when 0..1 then 'inactive'
    else 'excellent'
    end
  end
end
