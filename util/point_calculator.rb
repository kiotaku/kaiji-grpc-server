class PointCalculator
  class << self
    def blackjack_card_points(hands)
      points = hands.sum do |_suit, number|
        if number > 10
          10
        elsif number == 1
          11
        else
          number
        end
      end
      if points > 21
        points = hands.sum do |_suit, number|
          if number > 10
            10
          else
            number
          end
        end
      end
      points
    end

    def blackjack_game_points(user_id, hands_id, dealer_points, bet_points)
      if !Hand.busted?(hands_id)
        player_points = PointCalculator.blackjack_card_points(
          Hand.hands(hands_id)
        )
        blackjack_game_result(user_id, player_points, dealer_points, bet_points)
      else
        { userId: user_id, gameResult: 0, gotPoints: 0 }
      end
    end

    def blackjack_game_result(user_id, player_points, dealer_points, bet_points)
      bet_points *= 1.5 if player_points == 21
      if dealer_points < 21
        if player_point < dealer_points
          { userId: user_id, gameResult: 0, gotPoints: 0 }
        elsif player_point > dealer_points
          User.add_point(user_id, bet_points)
          { userId: user_id, gameResult: 2, gotPoints: bet_points }
        else
          User.add_point(user_id, bet_points / 2)
          { userId: user_id, gameResult: 1, gotPoints: bet_points / 2 }
        end
      else
        User.add_point(user_id, bet_points)
        { userId: user_id, gameResult: 2, gotPoints: bet_points }
      end
    end

    def poker_hands_role(hands)
      hands.sort_by! { |item| item[1] }
      hands.reverse!
      hands_group_num = hands.group_by { |item| item[1] }
      hands_group_length = hands_group_num.group_by { |k, v| v.length }
      return 10 if is_flush?(hands) && is_royal?(hands)
      return 9 if is_flush?(hands) && is_straight?(hands)
      return 8 if hands_group_length.has_key?(4)
      return 7 if hands_group_length.has_key?(3) && hands_group_length.has_key?(2)
      return 6 if is_flush?(hands)
      return 5 if is_straight?(hands)
      return 4 if hands_group_length.has_key?(3)
      return 3 if hands_group_length.has_key?(2) && hands_group_length[2].length == 2
      return 2 if hands_group_length.has_key?(2)
      1
    end

    def is_flush?(hands)
      hands = hands.group_by { |item| item[0] }
      hands.keys.length == 1
    end

    def is_royal?(hands)
      return false unless hands[4][1] == 1
      number = 13
      state = true
      hands[0..3].each do |hand|
        state &&= hand[1] == number
        number -= 1
      end
      state
    end

    def is_straight?(hands)
      number = hands[0][1]
      state = true
      hands.each do |hand|
        state &&= hand[1] == number
        number -= 1
      end
      state
    end

    def poker_game_result(room_id, user_id)
      point = PokerPlayer.user_card_point(room_id, user_id)
      max_point = PokerRoom.player_max_card_ponit(room_id, user_id)
      if point < max_point
        0
      elsif point == max_point
        second_point = PokerPlayer.user_card_point_second(room_id, user_id)
        max_second_point = PokerRoom.player_max_card_ponit_second(room_id, user_id)
        if second_point < max_second_point
          return 0
        elsif second_point > max_second_point
          return 2
        else
          return 1
        end
      else
        2
      end
    end

    def poker_win_point(hands_id, bet_points)
      role = Hand.role(hands_id)
      case role
      when 10
        return bet_points * 100
      when 9
        return bet_points * 20
      when 8
        return bet_points * 15
      when 7
        return bet_points * 10
      when 6
        return bet_points * 7
      when 5
        return bet_points * 6
      when 4
        return bet_points * 5
      when 3
        return bet_points * 4
      when 2
        return bet_points * 3
      when 1
        return bet_points * 2
      end
      0
    end
  end
end
