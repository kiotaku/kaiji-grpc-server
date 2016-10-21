require_relative './../../model/event_switch'
class CreateEventSwitches < ActiveRecord::Migration
  def up
    create_table :event_switches do |t|
      t.string :event_name, null: false
      t.boolean :is_valid, default: false, null: false
    end

    ['blackjack_three_times', 'baccarat_return_1.5_times'].each do |name|
      EventSwitch.create(event_name: name)
    end
  end

  def down
    drop_table :event_switches
  end
end
