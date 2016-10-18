class CreateBaccaratPlayers < ActiveRecord::Migration
  def up
    create_table :baccarat_players do |t|
      t.integer :baccarat_room_id, null: false
      t.integer :user_id, null: false
      t.integer :bet_points, default: 0, null: false
      t.integer :bet_side, default: 4, null: false
    end
  end

  def down
    drop_table :baccarat_players
  end
end
