class AddAllInFromPokerPlayers < ActiveRecord::Migration
  def up
    add_column :poker_players, :all_in, :boolean, default: false, null: false
  end

  def down
    remove_column :poker_players, :all_in
  end
end
