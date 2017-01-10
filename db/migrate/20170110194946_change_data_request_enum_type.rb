class ChangeDataRequestEnumType < ActiveRecord::Migration[5.0]
  def up
    remove_column :data_requests, :status
    add_column :data_requests, :status, :integer, null: false, default: 0
  end

  def down
    change_column :data_requests, :status, :string
  end
end
