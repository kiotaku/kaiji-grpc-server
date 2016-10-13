class CreateClients < ActiveRecord::Migration
  def up
    create_table :clients do |t|
      t.string :access_token
      t.string :access_key
      t.integer :login_status
    end
  end

  def down
    drop_table :clients
  end
end
