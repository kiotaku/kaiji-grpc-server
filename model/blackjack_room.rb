require 'securerandom'

class BlackjackRoom < ActiveRecord::Base
  has_one :user

  def create_room(user_id, bet_points)
    room = BlackjackRoom.create(
      user_id: user_id, bet_points: bet_points,
      user_hands_id_first: SecureRandom.hex(16),
      dealer_hands_id: SecureRandom.hex(16)
    )
    room.id
  end
end
