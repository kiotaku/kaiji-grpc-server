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

    def call(room_id, user_id)
      player = find_in_room(room_id, user_id)
      points = difference_max_bet(room_id, user_id)
      return 1 unless User.has_points?(user_id, points)
      User.reduce_point(user_id, points)
      player.update(bet_points: PokerRoom.player_max_bet(room_id))
      0
    end

    def raise(room_id, user_id, raise_points)
      player = find_in_room(room_id, user_id)
      next_points = player.bet_points + raise_points
      return 1 unless User.has_points?(user_id, raise_points)
      return 2 if PokerRoom.player_max_bet(room_id) > next_points
      User.reduce_point(user_id, raise_points)
      player.update(bet_points: next_points)
      0
    end

    def difference_max_bet(room_id, user_id)
      PokerRoom.player_max_bet(room_id) - find_in_room(room_id, user_id).bet_points
    end

    def remove_players(room_id)
      players = PokerPlayer.where(poker_room_id: room_id)
      players.map do |player|
        Hand.delete_hands(player.hands_id)
      end
      players.destroy_all
    end

    private

    def find_in_room(room_id, user_id)
      PokerPlayer.where(poker_room_id: room_id, user_id: user_id).first
    end
  end
end
