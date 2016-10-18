class BaccaratPlayer < ActiveRecord::Base

  @bet_side = {
    PLAYER: 0,
    BANKER: 1,
    TIE: 2
  }

  class << self
    def add_players(room_id, user_ids)
      user_ids.each do |user_id|
        BaccaratPlayer.create(
          baccarat_room_id: room_id,
          user_id: user_id
        )
      end
    end

    def bet(room_id, user_id, bet_points, bet_side)
      return 1 unless User.has_points?(user_id, bet_points)
      find_in_room(room_id, user_id).update(bet_points: bet_points, bet_side: @bet_side[bet_side])
      User.reduce_point(user_id, bet_points)
      0
    end

    def all_user_betted?(room_id)
      state = true
      BaccaratPlayer.where(baccarat_room_id: room_id).each do |player|
        state &&= !player.bet_points.zero?
      end
      state
    end

    def remove_players(room_id)
      BaccaratPlayer.where(baccarat_room_id: room_id).destroy_all
    end

    private

    def find_in_room(room_id, user_id)
      BaccaratPlayer.where(baccarat_room_id: room_id, user_id: user_id).first
    end
  end
end
