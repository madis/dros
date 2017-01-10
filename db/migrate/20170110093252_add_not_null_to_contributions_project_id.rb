class AddNotNullToContributionsProjectId < ActiveRecord::Migration[5.0]
  def change
    change_column_null :contributions, :project_id, false
  end
end
