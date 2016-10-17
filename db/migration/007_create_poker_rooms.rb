class CreatePokerRooms < ActiveRecord::Migration
  def up
    create_table :poker_rooms do |t|
      t.string :poker_players_id, null: false
    end
  end

  def down
    drop_table :poker_rooms
  end
end
