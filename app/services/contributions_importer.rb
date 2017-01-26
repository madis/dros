# Imports weekly project contributions excluding weeks with zero contributions
class ContributionsImporter
  CONTRIBUTION_COLUMNS = %i(project_id author week additions deletions commits created_at updated_at).freeze

  # Re-imports all passed in data for project
  #
  # Because Github contribution statistics api does not support querying for
  # date range, we already have the full JSON parsed by the time we get here.
  #
  # Optimizing by only inserting rows not yet in the database would require
  # additional queries and should be considered in the future.
  def self.import(stats, project_id)
    ActiveRecord::Base.transaction do
      remove_existing_contributions(project_id)
      import_new_contributions(stats, project_id)
    end
  end

  def self.remove_existing_contributions(project_id)
    Contribution.where(project_id: project_id).destroy_all
  end

  def self.import_new_contributions(stats, project_id)
    data_columns = [:a, :d, :c]
    Contribution.bulk_insert(*CONTRIBUTION_COLUMNS) do |worker|
      stats.each do |stat_row|
        stat_row[:weeks].each do |week|
          data_values = week.to_h.values_at(*data_columns)
          next if data_values.all?(&:zero?)
          worker.add [project_id, stat_row.dig(:author, :login), week[:w], *data_values]
        end
      end
    end
  end
end
