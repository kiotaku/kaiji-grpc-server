class BaccaratRoom < ActiveRecord::Base
  class << self
    def create_room(user_ids)
      room = BaccaratRoom.create
      BaccaratPlayer.add_players(room.id, user_ids)
      room
    end

    def destroy_room(room_id)
      room = BaccaratRoom.find_by_id(room_id)
      BaccaratPlayer.remove_players(room.id)
      room.destroy
    end
  end
end
