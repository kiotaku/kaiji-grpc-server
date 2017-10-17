require 'securerandom'

class BlackjackPlayer < ActiveRecord::Base
  RESULT_MAP = {
    'win': :WIN,
    'lose': :LOSE,
    'tie': :TIE,
    'blackjack': :WIN_BLACKJACK
  }

  def user_game_result(result)
    PointCalculator.blackjack_game_result(user_id, RESULT_MAP[result.to_sym], bet_points)
  end

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

    def exist_in_room?(room_id, user_id)
      find_in_room(room_id, user_id).present?
    end

    def can_bet?(room_id, user_id)
      player = find_in_room(room_id, user_id)
      player.bet_points.zero?
    end

    def bet_points(room_id, user_id, points)
      find_in_room(room_id, user_id).update(bet_points: points)
    end

    def remove_players(room_id)
      players = BlackjackPlayer.where(blackjack_room_id: room_id)
      BlackjackPlayer.where(blackjack_room_id: room_id).destroy_all
    end

    def find_in_room(room_id, user_id)
      BlackjackPlayer.where(blackjack_room_id: room_id, user_id: user_id).first
    end
  end
end
