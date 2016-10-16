class AddIsStandFromHands < ActiveRecord::Migration
  def up
    add_column :hands, :is_stand, :boolean, default: false, null: false
  end

  def down
    remove_column :hands, :is_stand
  end
end
