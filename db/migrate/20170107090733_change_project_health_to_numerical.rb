class ChangeProjectHealthToNumerical < ActiveRecord::Migration[5.0]
  class Project < ActiveRecord::Base; end

  def up
    remove_column :projects, :health
    add_column :projects, :health, :integer, null: false, default: 0
  end

  def down
    change_column :projects, :health, :string
  end
end
