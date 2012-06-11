class RoomsChangeSidToString < ActiveRecord::Migration
  def change
    change_column :rooms, :sid, :string
  end
end
