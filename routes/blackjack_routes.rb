class BlackjackRoutes < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    response.headers["Access-Control-Allow-Origin"] = "*"
    if request.request_method == 'OPTIONS'
      response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

      halt 200
    end
  end

  post('/create_new_game_room') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    begin
      room = BlackjackRoom.create_room(params[:userIds])
    rescue
      json isSucceed: false
    else
      json isSucceed: true, gameRoomId: room.id
    end
  end

  post('/betting') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    json result: BlackjackRoom.betting(params[:gameRoomId], params[:userId], params[:betPoints].to_i),
         userId: params[:userId]
  end

  post('/set_game_result') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    json isSucceed: true,
         playerResults: BlackjackRoom.result_room(params[:gameRoomId], params[:results])
  end

  post('/destroy_game_room') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    begin
      BlackjackRoom.destroy_room(params[:gameRoomId])
    rescue
      json isSucceed: false
    else
      json isSucceed: true
    end
  end
end
