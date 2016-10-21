class Hand < ActiveRecord::Base

  @suits = {
    SPADE:   0,
    CLUB:    1,
    HEART:   2,
    DIAMOND: 3
  }

  @suit_stregths - {
    0 => 3,
    2 => 2,
    3 => 1,
    1 => 0
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

    def max_pair_card(hands_id)
      hands = Hand.hands(hands_id)
      hands = hands.map { |item| [@suit_stregths[item[0]], item[1]] }
      hands_group_num = hands.group_by { |item| item[1] }
      hands_group_length = hands_group_num.group_by { |k, v| v.length }
      card = hands_group_length[hands_group_length.keys.max].max[1].sort.reverse[0]
      card[1] * 10 + 3 - card[0]
    end

    def max_pair_card_second(hands_id)
      hands = Hand.hands(hands_id)
      hands = hands.map { |item| [@suit_stregths[item[0]], item[1]] }
      hands_group_num = hands.group_by { |item| item[1] }
      hands_group_length = hands_group_num.group_by { |k, v| v.length }
      card = hands_group_length[hands_group_length.keys.sort.reverse[1]].max[1].sort.reverse[0]
      card[1] * 10 + 3 - card[0]
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
