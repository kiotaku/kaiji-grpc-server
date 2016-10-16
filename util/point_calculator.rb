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
  end
end
