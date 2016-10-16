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
  end
end
