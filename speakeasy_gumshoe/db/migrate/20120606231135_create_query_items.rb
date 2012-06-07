class CreateQueryItems < ActiveRecord::Migration
  def change
    create_table :query_items do |t|
      t.string :query
      t.text :content

      t.timestamps
    end
  end
end
