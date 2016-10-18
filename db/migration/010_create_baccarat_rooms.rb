class CreateBaccaratRooms < ActiveRecord::Migration
  def up
    create_table :baccarat_rooms do |t|
      t.integer :result, default: 0, null: false
    end
  end

  def down
    drop_table :baccarat_rooms
  end
end
