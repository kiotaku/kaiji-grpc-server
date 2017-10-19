class PokerRoutes < Sinatra::Base
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
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    begin
      room = PokerRoom.create_room(params[:userIds])
    rescue
      json isSucceed: false
    else
      json isSucceed: true,
           gameRoomId: room.id
    end
  end

  post('/call') do
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    result = PokerPlayer.call(params[:gameRoomId], params[:userId])
    json result: result,
         userId: params[:userId],
         isAllIn: PokerPlayer.find_in_room(params[:gameRoomId], params[:userId]).all_in,
         nextPlayersAvailableActions: ActionChecker.poker_available_action(params[:gameRoomId], params[:userId])
  end

  post('/raise') do
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    result = PokerPlayer.raise(params[:gameRoomId], params[:userId], params[:betPoints].to_i)
    json result: result,
         userId: params[:userId],
         nextPlayersAvailableActions: ActionChecker.poker_available_action(params[:gameRoomId], params[:userId]),
         fieldBetPoints: PokerRoom.player_max_bet(params[:gameRoomId])
  end

  post('/check') do
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    json nothing: 'to do'
  end

  post('/fold') do
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    result = PokerPlayer.fold(params[:gameRoomId], params[:userId])
    json isSucceed: result,
         userId: params[:userId],
         nextPlayersAvailableActions: ActionChecker.poker_available_action(params[:gameRoomId], params[:userId])
  end

  post('/set_winner') do
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    results = PokerRoom.room_game_result(params[:gameRoomId], params[:winnerId])
    json isSucceed: true,
         playerResults: results
  end

  post('/destroy_game_room') do
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    begin
      PokerRoom.destroy_room(params[:gameRoomId])
    rescue
      json isSucceed: false
    else
      json isSucceed: true
    end
  end
end
