class ActionChecker
  class << self
    def split(hands)
      hands.length == 2 && hands[0] == hands[1]
    end

    def double_down(hands)
      hands.length == 2
    end

    def dealer_should_hit?(card_points)
      card_points < 17
    end

    def poker_available_action(room_id, user_id)
      actions = []
      if User.has_points?(user_id, PokerPlayer.difference_max_bet(room_id, user_id))
        actions.push(2)
        actions.push(3)
      end
      actions.push(5)
      actions.push(6)
      actions
    end
  end
end
