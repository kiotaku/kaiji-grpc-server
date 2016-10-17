require 'securerandom'

class PokerRoom < ActiveRecord::Base
  class << self
    def create_room(user_ids)
      room = PokerRoom.create(
        poker_players_id: SecureRandom.hex(16)
      )
      PokerPlayer.add_players(room.id, user_ids)
      room
    end

    def destroy_room(room_id)
      room = PokerRoom.find_by_id(room_id)
      PokerPlayer.remove_players(room.id)
      room.destroy
    end
  end
end
