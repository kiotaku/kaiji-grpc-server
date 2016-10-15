class CreateBlackjackPlayers < ActiveRecord::Migration
  def up
    create_table :blackjack_players do |t|
      t.integer :blackjack_room_id, null: false
      t.integer :user_id, null: false
      t.string :hands_id_first, null: false
      t.string :hands_id_second
      t.integer :bet_points, default: 0, null: false
      t.boolean :is_split, default: false, null: false
      t.boolean :is_double_down, default: false, null: false
    end
  end

  def down
    drop_table :blackjack_players
  end
end
