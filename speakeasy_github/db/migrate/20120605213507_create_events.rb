class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :repository_id
      t.string :data

      t.timestamps
    end
  end
end
