class CreateBlackjackRooms < ActiveRecord::Migration
  def up
    create_table :blackjack_rooms do |t|
      t.integer :room_id
      t.integer :user_hands_id_first
      t.integer :user_hands_id_second
      t.integer :dealer_hands_id
      t.integer :bet_points
      t.boolean :is_split
      t.boolean :is_double_down
    end
  end

  def down
    drop_table :blackjack_rooms
  end
end
