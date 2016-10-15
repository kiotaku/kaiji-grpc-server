require 'securerandom'

class BlackjackRoom < ActiveRecord::Base
  class << self
    def create_room(user_ids)
      room = BlackjackRoom.create(
        blackjack_players_id: SecureRandom.hex(16),
        dealer_hands_id: SecureRandom.hex(16)
      )
      BlackjackPlayer.add_players(room.id, user_ids)
      room
    end

    def destroy_room(room_id)
      room = BlackjackRoom.find(room_id)
      BlackjackPlayer.remove_players(room.id)
      Hand.delete_hands(room.dealer_hands_id)
      room.destroy
    end
  end
end
