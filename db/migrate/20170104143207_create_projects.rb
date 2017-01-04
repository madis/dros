class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :owner
      t.string :repo
      t.string :health

      t.timestamps
    end
  end
end
