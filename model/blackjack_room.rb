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

  def create_room(user_id, bet_points)
    room = BlackjackRoom.create(
      user_id: user_id, bet_points: bet_points,
      user_hands_id_first: SecureRandom.hex(16),
      dealer_hands_id: SecureRandom.hex(16)
    )
    room.id
  end
end
