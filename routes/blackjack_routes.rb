class BlackjackRoutes < Sinatra::Base
  post('/create_new_game_room') do
    begin
      room = BlackjackRoom.create_room(params[:usersId])
    rescue
      json isSucceed: false
    else
      json isSucceed: true, gameRoomId: room.id
    end
  end

  post('/betting') do
    json result: BlackjackRoom.betting(params[:gameRoomId], params[:userId], params[:betPoints]),
         userId: req.userId
  end

  post('/set_game_result') do
    json isSucceed: true,
         playerResults: BlackjackRoom.result_room(params[:gameRoomId])
  end

  post('/destroy_game_room') do
    begin
      BlackjackRoom.destroy_room(req.gameRoomId)
    rescue
      json isSucceed: false
    else
      json isSucceed: true
    end
  end
end
