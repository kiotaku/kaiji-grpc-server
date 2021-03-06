class ActionChecker
  class << self
    def split(hands, user_id, bet_points)
      hands.length == 2 && hands[0] == hands[1] && User.has_points?(user_id, bet_points)
    end

    def double_down(hands, user_id, bet_points)
      hands.length == 2 && User.has_points?(user_id, bet_points)
    end

    def dealer_should_hit?(card_points)
      card_points < 17
    end

    def poker_available_action(room_id, user_id)
      actions = []
      unless PokerPlayer.fold?(room_id, user_id)
        actions.push(2)
        if User.has_points?(user_id, PokerPlayer.difference_max_bet(room_id, user_id))
          actions.push(3)
        end
        actions.push(5)
      end
      actions.push(6)
      actions
    end
  end
end
