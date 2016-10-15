class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users, id: false do |t|
      t.integer :id, null: false, unique: true
      t.string :name, default: 'anonymous'
      t.integer :points, default: 10_000, null: false
      t.boolean :is_available, default: true, null: false
      t.boolean :is_anonymous, default: true, null: false
      t.integer :continue_count, default: 0, null: false
    end
  end

  def down
    drop_table :users
  end
end
