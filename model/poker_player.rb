require 'securerandom'

class PokerPlayer < ActiveRecord::Base
  class << self
    def add_players(room_id, user_ids)
      user_ids.each_with_index do |user_id, i|
        PokerPlayer.create(
          poker_room_id: room_id,
          user_id: user_id,
          hands_id: SecureRandom.hex(16)
        )
        if i == 0
          raise(room_id, user_id, 100)
        else
          call(room_id, user_id)
        end
      end
    end

    def call(room_id, user_id)
      player = find_in_room(room_id, user_id)
      points = difference_max_bet(room_id, user_id)
      if User.has_points?(user_id, points)
        User.reduce_point(user_id, points)
        player.update(bet_points: PokerRoom.player_max_bet(room_id))
      elsif User.find_by_id(user_id).points >= 100
        points = User.all_in(user_id)
        player.update(bet_points: points + player.bet_points, all_in: true)
      end
      0
    end

    def raise(room_id, user_id, raise_points)
      call(room_id, user_id)
      player = find_in_room(room_id, user_id)
      next_points = player.bet_points + raise_points
      return 1 unless User.has_points?(user_id, raise_points)
      return 2 if PokerRoom.player_max_bet(room_id) > next_points
      User.reduce_point(user_id, raise_points)
      player.update(bet_points: next_points)
      0
    end

    def fold(room_id, user_id)
      player = find_in_room(room_id, user_id)
      player.update(is_fold: true)
    end

    def fold?(room_id, user_id)
      find_in_room(room_id, user_id).is_fold
    end

    def set_hands(room_id, user_id, cards)
      player = find_in_room(room_id, user_id)
      cards.each do |card|
        Hand.add_hand(player.hands_id, card)
      end
    end

    def user_role(room_id, user_id)
      Hand.role(find_in_room(room_id, user_id).hands_id)
    end

    def user_card_point(room_id, user_id)
      role = user_role(room_id, user_id)
      role * 1000 + Hand.max_pair_card(find_in_room(room_id, user_id).hands_id)
    end

    def difference_max_bet(room_id, user_id)
      PokerRoom.player_max_bet(room_id) - find_in_room(room_id, user_id).bet_points
    end

    def remove_players(room_id)
      players = PokerPlayer.where(poker_room_id: room_id)
      players.map do |player|
        Hand.delete_hands(player.hands_id)
      end
      players.destroy_all
    end

    def find_in_room(room_id, user_id)
      PokerPlayer.where(poker_room_id: room_id, user_id: user_id).first
    end
  end
end
