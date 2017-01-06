class CreateContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :contributions do |t|
      t.string :author, null: false
      t.integer :week, null: false
      t.integer :additions, null: false
      t.integer :deletions, null: false
      t.integer :commits, null: false
      t.references :project, foreign_key: true

      t.timestamps
    end
  end
end
