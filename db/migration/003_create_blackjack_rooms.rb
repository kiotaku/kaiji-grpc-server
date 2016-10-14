class CreateBlackjackRooms < ActiveRecord::Migration
  def up
    create_table :blackjack_rooms do |t|
      t.integer :room_id, null: false
      t.integer :user_id, null: false
      t.integer :user_hands_id_first, null: false
      t.integer :user_hands_id_second
      t.integer :dealer_hands_id, null: false
      t.integer :bet_points, null: false
      t.boolean :is_split, default: false, null: false
      t.boolean :is_double_down, default: false, null: false
    end
  end

  def down
    drop_table :blackjack_rooms
  end
end
