class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.string :sid
      t.integer :room_id

      t.timestamps
    end
  end
end
