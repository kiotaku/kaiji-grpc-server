require 'securerandom'

class BlackjackPlayer < ActiveRecord::Base
  class << self
    def add_players(room_id, user_ids)
      user_ids.each do |user_id|
        BlackjackPlayer.create(
          blackjack_room_id: room_id,
          user_id: user_id,
          hands_id_first: SecureRandom.hex(16)
        )
      end
    end

    def remove_players(room_id)
      BlackjackPlayer.where(room_id).map do |player|
        Hand.delete_hands(player.hands_id_first)
        if player.hands_id_second.present?
          Hand.delete_hands(player.hands_id_second)
        end
      end
      BlackjackPlayer.destroy_all(blackjack_room_id: room_id)
    end
  end
end
