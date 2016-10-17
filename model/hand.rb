class Hand < ActiveRecord::Base

  @suits = {
    SPADE:   0,
    CLUB:    1,
    HEART:   2,
    DIAMOND: 3
  }

  class << self
    def hands(hands_id)
      Hand.where(hands_id: hands_id).pluck(:suit, :number)
    end

    def add_hand(hands_id, card)
      Hand.create(
        hands_id: hands_id,
        suit: @suits[card.suit],
        number: card.number
      )
    end

    def role(hands_id)
      PointCalculator.poker_hands_role(Hand.hands(hands_id))
    end

    def busted?(hands_id)
      PointCalculator.blackjack_card_points(hands(hands_id)) > 21
    end

    def stand(hands_id)
      Hand.where(hands_id: hands_id).update_all(is_stand: true)
    end

    def is_stand?(hands_id)
      Hand.where(hands_id: hands_id).first.is_stand
    end

    def delete_hands(hands_id)
      Hand.where(hands_id: hands_id).destroy_all
    end
  end
end
