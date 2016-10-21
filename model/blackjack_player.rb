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

    def add_user_hand(room_id, user_id, card, is_second)
      _add_user_hand(find_in_room(room_id, user_id), card, is_second)
    end

    def user_hands_busted?(room_id, user_id, is_second)
      player = find_in_room(room_id, user_id)
      if is_second
        Hand.busted?(player.hands_id_second)
      else
        Hand.busted?(player.hands_id_first)
      end
    end

    def user_hands_point(room_id, user_id, is_second)
      player = find_in_room(room_id, user_id)
      hands = Hand.hands(is_second ? player.hands_id_second : player.hands_id_first)
      PointCalculator.blackjack_card_points(hands)
    end

    def can_user_first_action?(room_id)
      players = BlackjackPlayer.where(blackjack_room_id: room_id)
      players.map do |player|
        first_hands = Hand.hands(player.hands_id_first)
        points = PointCalculator.blackjack_card_points(first_hands)
        can_split = ActionChecker.split(first_hands, player.user_id, player.bet_points)
        can_double_down = ActionChecker.double_down(first_hands, player.user_id, player.bet_points)
        actions = []
        actions.push(1, 2) if user_hands_busted?(room_id, player.user_id, false)
        actions.push(3) if can_split
        actions.push(4) if can_double_down
        { userId: player.user_id, cardPoints: points, actions: actions }
      end
    end

    def can_user_action?(room_id, user_id, is_second)
      return [] if user_hands_busted?(room_id, user_id, is_second)
      [1, 2]
    end

    def user_hands_stand(room_id, user_id, is_second)
      player = find_in_room(room_id, user_id)
      Hand.stand(is_second ? player.hands_id_second : player.hands_id_first)
    end

    def user_hands_split(room_id, user_id)
      player = find_in_room(room_id, user_id)
      return false unless bet_points_twice(player)
      player.update(hands_id_second: SecureRandom.hex(16), is_split: true)
      Hand.where(hands_id: player.hands_id_first).first.update(hands_id: player.hands_id_second)
    end

    def user_hands_split?(room_id, user_id)
      find_in_room(room_id, user_id).is_split
    end

    def user_hands_double_down(room_id, user_id, card)
      player = find_in_room(room_id, user_id)
      return false unless bet_points_twice(player)
      player.update(is_double_down: true)
      _add_user_hand(player, card, false)
      !Hand.stand(player.hands_id_first).zero?
    end

    def bet_points_twice(player)
      bet_points = player.bet_points
      if User.has_points?(player.user_id, bet_points)
        User.reduce_point(player.user_id, bet_points)
        player.update(bet_points: bet_points * 2)
      else
        false
      end
    end

    def user_game_result(room_id, dealer_hands)
      players = BlackjackPlayer.where(blackjack_room_id: room_id)
      players.map do |player|
        results = []
        if player.is_split
          results.push PointCalculator.blackjack_game_points(
            player.user_id,
            player.hands_id_first,
            dealer_hands,
            player.bet_points
          )
          results.push PointCalculator.blackjack_game_points(
            player.user_id,
            player.hands_id_second,
            dealer_hands,
            player.bet_points
          )
        else
          results.push PointCalculator.blackjack_game_points(
            player.user_id,
            player.hands_id_first,
            dealer_hands,
            player.bet_points * 2
          )
        end
        results
      end
    end

    def remove_players(room_id)
      players = BlackjackPlayer.where(blackjack_room_id: room_id)
      players.map do |player|
        Hand.delete_hands(player.hands_id_first)
        if player.hands_id_second.present?
          Hand.delete_hands(player.hands_id_second)
        end
      end
      BlackjackPlayer.where(blackjack_room_id: room_id).destroy_all
    end

    def find_in_room(room_id, user_id)
      BlackjackPlayer.where(blackjack_room_id: room_id, user_id: user_id).first
    end

    private

    def _add_user_hand(player, card, is_second)
      if is_second
        Hand.add_hand(player.hands_id_second, card)
      else
        Hand.add_hand(player.hands_id_first, card)
      end
    end
  end
end
