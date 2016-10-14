class CreateHands < ActiveRecord::Migration
  def up
    create_table :hands do |t|
      t.integer :hands_id, null: false
      t.integer :suit, null: false
      t.integer :number, null: false
    end
  end

  def down
    drop_table :hands
  end
end
