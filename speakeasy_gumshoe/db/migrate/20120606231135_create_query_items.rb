class CreateQueryItems < ActiveRecord::Migration
  def change
    create_table :query_items do |t|
      t.string :query
      t.text :content
      t.string :ns

      t.timestamps
    end
  end
end
