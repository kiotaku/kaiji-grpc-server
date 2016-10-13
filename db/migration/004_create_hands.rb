class CreateHands < ActiveRecord::Migration
  def up
    create_table :hands do |t|
      t.integer :hands_id
      t.integer :suit
      t.integer :number
    end
  end

  def down
    drop_table :hands
  end
end
