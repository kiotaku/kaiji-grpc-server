class CreateBlackjackRooms < ActiveRecord::Migration
  def up
    create_table :blackjack_rooms do |t|
      t.string :blackjack_players_id, null: false
      t.string :dealer_hands_id, null: false
    end
  end

  def down
    drop_table :blackjack_rooms
  end
end
