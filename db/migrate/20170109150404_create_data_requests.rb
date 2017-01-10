class CreateDataRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :data_requests do |t|
      t.string :slug, null: false
      t.string :status, null: false, default: 'created'
      t.timestamps
    end
  end
end
