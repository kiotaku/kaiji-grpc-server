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

    def player_max_bet(room_id)
      players = PokerPlayer.where(poker_room_id: room_id)
      bet_points_list = players.map { |player| player.bet_points }
      bet_points_list.max
    end

    def players_bet_sum(room_id)
      players = PokerPlayer.where(poker_room_id: room_id)
      bet_points_list = players.map { |player| player.bet_points }
      bet_points_sum = bet_points_list.inject { |sum, item| sum + item }
      bet_points_sum
    end

    def room_game_result(room_id, winner)
        players = PokerPlayer.where(poker_room_id: room_id)
        get_point = PointCalculator.poker_win_point(room_id)
        players.map do |player|
          if player.user_id == winner
            User.add_point(player.user_id, get_point)
            User.reduce_point(player.user_id, 1) if player.all_in
            {
              userId: player.user_id,
              gameResult: :win,
              gotPoints: get_point
            }
          else
            {
              userId: player.user_id,
              gameResult: :lose,
              gotPoints: 0
            }
          end
      end
    end

    def destroy_room(room_id)
      room = PokerRoom.find_by_id(room_id)
      PokerPlayer.remove_players(room.id)
      room.destroy
    end
  end
end
