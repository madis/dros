class AddRepoAgeToRepoInfo < ActiveRecord::Migration[5.0]
  def change
    add_column :repo_infos, :repo_created_at, :datetime
    add_column :repo_infos, :repo_pushed_at, :datetime
    add_column :repo_infos, :repo_updated_at, :datetime
  end
end
