require 'securerandom'

class BlackjackRoom < ActiveRecord::Base
  class << self
    def create_room(user_ids)
      room = BlackjackRoom.create(
        blackjack_players_id: SecureRandom.hex(16),
        dealer_hands_id: SecureRandom.hex(16)
      )
      BlackjackPlayer.add_players(room.id, user_ids)
      room
    end

    def betting(room_id, user_id, bet_points)
      return 3 unless BlackjackPlayer.exist_in_room?(room_id, user_id)
      return 2 unless BlackjackPlayer.can_bet?(room_id, user_id)
      return 1 unless User.has_points?(user_id, bet_points)
      BlackjackPlayer.bet_points(room_id, user_id, bet_points)
      User.reduce_point(user_id, bet_points)
      0
    end

    def add_dealer_hand(room_id, card)
      Hand.add_hand(
        BlackjackRoom.find_by_id(room_id).dealer_hands_id,
        card
      )
    end

    def dealer_hands(room_id)
      Hand.hands(BlackjackRoom.find_by_id(room_id).dealer_hands_id)
    end

    def dealer_hands_busted?(room_id)
      Hand.busted?(BlackjackRoom.find_by_id(room_id).dealer_hands_id)
    end

    def result_room(room_id)
      dealer_card_points = PointCalculator.blackjack_card_points(dealer_hands(room_id))
      BlackjackPlayer.user_game_result(room_id, dealer_card_points)
    end

    def destroy_room(room_id)
      room = BlackjackRoom.find_by_id(room_id)
      BlackjackPlayer.remove_players(room.id)
      Hand.delete_hands(room.dealer_hands_id)
      room.destroy
    end
  end
end
