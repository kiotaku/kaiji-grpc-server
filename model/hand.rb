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

    def delete_hands(hands_id)
      Hand.where(hands_id: hands_id).destroy_all
    end
  end
end
