class CreateRepoInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :repo_infos do |t|
      t.string :description
      t.integer :size, null: false, default: 0
      t.integer :watchers, null: false, default: 0
      t.integer :stars, null: false, default: 0
      t.integer :forks, null: false, default: 0
      t.string :language
      t.references :project, foreign_key: true, null: false

      t.timestamps
    end
  end
end
