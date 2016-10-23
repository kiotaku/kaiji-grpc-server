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

    def blackjack_game_points(user_id, hands_id, dealer_hands, bet_points)
      if !Hand.busted?(hands_id)
        blackjack_game_result(user_id, Hand.hands(hands_id), dealer_hands, bet_points)
      else
        User.reduce_point(user_id, 1) if User.find_by_id(user_id).points <= 1
        { userId: user_id, gameResult: 0, gotPoints: 0 }
      end
    end

    def blackjack_game_result(user_id, player_hands, dealer_hands, bet_points)
      player_points = blackjack_card_points(player_hands)
      dealer_points = blackjack_card_points(dealer_hands)
      is_zero_points = User.find_by_id(user_id).points <= 1
      case compare_point_and_hands(player_points, player_hands, dealer_points, dealer_hands)
      when :LOSE
        User.reduce_point(user_id, 1) if is_zero_points
        { userId: user_id, gameResult: 0, gotPoints: 0 }
      when :TIE
        User.add_point(user_id, bet_points / 2)
        User.reduce_point(user_id, 1) if is_zero_points
        { userId: user_id, gameResult: 1, gotPoints: bet_points / 2 }
      when :WIN
        User.add_point(user_id, bet_points)
        User.reduce_point(user_id, 1) if is_zero_points
        { userId: user_id, gameResult: 2, gotPoints: bet_points }
      when :WIN_BLACKJACK
        User.add_point(user_id, bet_points * 1.5)
        User.reduce_point(user_id, 1) if is_zero_points
        { userId: user_id, gameResult: 2, gotPoints: bet_points * 1.5 }
      end
    end

    def compare_point_and_hands(player_points, player_hands, dealer_points, dealer_hands)
      return :TIE if player_points == dealer_points && player_hands.length == dealer_hands.length
      return :LOSE if dealer_points == 21 && dealer_hands.length == 2
      return :WIN_BLACKJACK if player_points == 21 && player_hands.length == 2
      return :TIE if player_points == dealer_points
      return :WIN_BLACKJACK if EventSwitch.on?('blackjack_three_times') && player_points == 21
      return :WIN if player_points > dealer_points || dealer_points > 21
      :LOSE
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
      return 2 if max_point.blank?
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

    def poker_win_point(room_id)
        bet_points_sum = PokerRoom.players_bet_sum(room_id)
        field_points = PokerRoom.room_point(room_id)

        bet_points_sum + field_points if field_points.present?
        bet_points_sum + 200
    end

    def baccarat_hands_point(hands)
      points = hands.map do |hand|
        if hand[:number] >= 10 then 0
        else hand[:number]
        end
      end
      points = points.sum
      return points % 10 if points > 9
      points
    end
  end
end
