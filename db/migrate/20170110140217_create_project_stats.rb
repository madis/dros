class CreateProjectStats < ActiveRecord::Migration[5.0]
  def change
    create_table :project_stats do |t|
      t.float :weekly_commits_per_contributor_min, null: false, default: 0
      t.float :weekly_commits_per_contributor_max, null: false, default: 0
      t.float :weekly_commits_per_contributor_avg, null: false, default: 0
      t.float :weekly_commits_per_contributor_med, null: false, default: 0
      t.references :project, foreign_key: true, null: false

      t.timestamps
    end
  end
end
