class PointCalculator
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
    if point > 21
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
end
