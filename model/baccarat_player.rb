class BaccaratPlayer < ActiveRecord::Base
  class << self
    def add_players(room_id, user_ids)
      user_ids.each do |user_id|
        BaccaratPlayer.create(
          baccarat_room_id: room_id,
          user_id: user_id
        )
      end
    end

    def remove_players(room_id)
      BaccaratPlayer.where(baccarat_room_id: room_id).destroy_all
    end
  end
end
