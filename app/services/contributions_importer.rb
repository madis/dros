# Imports weekly project contributions excluding weeks with zero contributions
class ContributionsImporter
  CONTRIBUTION_COLUMNS = %i(project_id author week additions deletions commits created_at updated_at).freeze

  def self.import(stats, project_id)
    data_columns = [:a, :d, :c]
    Contribution.bulk_insert(*CONTRIBUTION_COLUMNS) do |worker|
      stats.each do |stat_row|
        stat_row[:weeks].each do |week|
          data_values = week.to_h.values_at(*data_columns)
          next if data_values.all?(&:zero?)
          worker.add [project_id, stat_row[:author][:login], week[:w], *data_values]
        end
      end
    end
  end
end
