class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :repo_url
      t.string :data

      t.timestamps
    end
  end
end
