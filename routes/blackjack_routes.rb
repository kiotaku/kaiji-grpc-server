class BlackjackRoutes < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

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
         userId: params[:userId]
  end

  post('/set_game_result') do
    json isSucceed: true,
         playerResults: BlackjackRoom.result_room(params[:gameRoomId], params[:results])
  end

  post('/destroy_game_room') do
    begin
      BlackjackRoom.destroy_room(params[:gameRoomId])
    rescue
      json isSucceed: false
    else
      json isSucceed: true
    end
  end
end
