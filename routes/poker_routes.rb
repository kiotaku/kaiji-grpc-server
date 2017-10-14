class PokerServer < Sinatra::Base
  post('/create_new_game_room') do
    begin
      room = PokerRoom.create_room(params[:usersId])
    rescue
      json isSucceed: false
    else
      json {
        isSucceed: true,
        gameRoomId: room.id
      }
    end
  end

  post('/call') do
    result = PokerPlayer.call(params[:gameRoomId], params[:userId])
    json {
      result: result,
      userId: params[:userId],
      isAllIn: PokerPlayer.find_in_room(params[:gameRoomId], params[:userId]).all_in,
      nextPlayersAvailableActions: ActionChecker.poker_available_action(params[:gameRoomId], params[:userId])
    }
  end

  post('/raise') do
    result = PokerPlayer.raise(params[:gameRoomId], params[:userId], params[:betPoints])
    json {
      result: result,
      userId: params[:userId],
      nextPlayersAvailableActions: ActionChecker.poker_available_action(params[:gameRoomId], params[:userId]),
      fieldBetPoints: PokerRoom.player_max_bet(params[:gameRoomId])
    }
  end

  post('/check') do
  end

  post('/fold') do
    result = PokerPlayer.fold(params[:gameRoomId], params[:userId])
    json {
      isSucceed: result,
      userId: params[:userId],
      nextPlayersAvailableActions: ActionChecker.poker_available_action(params[:gameRoomId], params[:userId])
    }
  end

  post('/set_winner') do
    results = PokerRoom.room_game_result(params[:gameRoomId])
    json {
      isSucceed: true,
      playerResults: results
    }
  end

  post('/destroy_game_room') do
    begin
      PokerRoom.destroy_room(params[:gameRoomId])
    rescue
      json isSucceed: false
    else
      json isSucceed: true
    end
  end
end
