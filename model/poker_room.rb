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

    def player_max_card_ponit(room_id, user_id)
      point = PokerPlayer.where(poker_room_id: room_id)
        .where.not(user_id: user_id, is_fold: true).map do |player|
        PokerPlayer.user_card_point(room_id, player.user_id)
      end
      point.max
    end

    def player_max_card_ponit_second(room_id, user_id)
      point = PokerPlayer.where(poker_room_id: room_id)
        .where.not(user_id: user_id, is_fold: true).map do |player|
        [
          PokerPlayer.user_card_point(room_id, player.user_id),
          PokerPlayer.user_card_point_second(room_id, player.user_id)
        ]
      end
      point.sort_by! { |item| item[0] }
      point.reverse[0][1]
    end

    def room_point(room_id)
      points = []
      PokerPlayer.where(poker_room_id: room_id).each do |player|
        points.push(player.points) if !player.all_in && player.points != 200
      end
      points.min
    end

    def room_game_result(room_id)
      players = PokerPlayer.where(poker_room_id: room_id)
      players.map do |player|
        result = PointCalculator.poker_game_result(room_id, player.user_id) unless player.is_fold
        result = 0 if player.is_fold
        get_point = PointCalculator.poker_win_point(room_id) if result == 2
        get_point = player.bet_points if result == 1
        get_point = 0 if result.zero?
        User.add_point(player.user_id, get_point)
        User.reduce_point(player.user_id, 1) if player.all_in
        {
          userId: player.user_id,
          gameResult: result,
          gotPoints: get_point
        }
      end
    end

    def destroy_room(room_id)
      room = PokerRoom.find_by_id(room_id)
      PokerPlayer.remove_players(room.id)
      room.destroy
    end
  end
end
