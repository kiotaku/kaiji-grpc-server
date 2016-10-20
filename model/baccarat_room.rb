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

    def game_results(room_id)
      winner = BaccaratRoom.find_by_id(room_id).result
      return { result: 1, playerResults: [] } if winner > 2
      results = BaccaratPlayer.where(baccarat_room_id: room_id).map do |player|
        got_points = get_points(winner, player.bet_side, player.bet_points)
        got_points * 1.5 if EventSwitch.on?('baccarat_return_1.5_times') && winner != player.bet_side
        User.add_point(player.user_id, got_points)
        {
          userId: player.user_id,
          gameResult: game_result(winner, player.bet_side),
          gotPoints: got_points
        }
      end
      { result: 0, playerResults: results }
    end

    def game_result(winner, bet_side)
      return 1 if winner == bet_side
      return 2 if winner == 2
      0
    end

    def get_points(winner, bet_side, bet_points)
      result = game_result(winner, bet_side)
      return 0 if result.zero?
      return bet_points if result == 2
      return bet_points * 10 if result == 1 && bet_side == 2
      bet_points * 2
    end

    def destroy_room(room_id)
      room = BaccaratRoom.find_by_id(room_id)
      BaccaratPlayer.remove_players(room.id)
      room.destroy
    end
  end
end
