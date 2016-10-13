class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users, id: false do |t|
      t.integer :id
      t.string :name
      t.integer :points
      t.boolean :is_available
      t.boolean :is_anonymous
      t.integer :continue_count
    end
  end

  def down
    drop_table :users
  end
end
