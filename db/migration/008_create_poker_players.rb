class CreatePokerPlayers < ActiveRecord::Migration
  def up
    create_table :poker_players do |t|
      t.integer :poker_room_id, null: false
      t.integer :user_id, null: false
      t.string :hands_id, null: false
      t.integer :bet_points, default: 0, null: false
      t.boolean :is_fold, default: false, null: false
    end
  end

  def down
    drop_table :poker_players
  end
end
