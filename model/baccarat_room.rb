class BaccaratRoom < ActiveRecord::Base
  class << self
    def create_room(user_ids)
      room = BaccaratRoom.create
      BaccaratPlayer.add_players(room.id, user_ids)
      room
    end

    def start_opening_cards(room_id)
      return 1 unless BaccaratPlayer.all_user_betted?(room_id)
      actions = Baccarat.emulate
      BaccaratRoom.find_by_id(room_id).update(result: actions.reverse[0][:winner])
      0
    end

    def destroy_room(room_id)
      room = BaccaratRoom.find_by_id(room_id)
      BaccaratPlayer.remove_players(room.id)
      room.destroy
    end
  end
end
