require 'securerandom'

class PokerPlayer < ActiveRecord::Base
  class << self
    def add_players(room_id, user_ids)
      user_ids.each do |user_id|
        PokerPlayer.create(
          poker_room_id: room_id,
          user_id: user_id,
          hands_id: SecureRandom.hex(16)
        )
      end
    end

    def remove_players(room_id)
      players = PokerPlayer.where(poker_room_id: room_id)
      players.map do |player|
        Hand.delete_hands(player.hands_id)
      end
      players.destroy_all
    end
  end
end
