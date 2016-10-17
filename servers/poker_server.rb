require_relative './../protoc_ruby/poker_services_pb'

class PokerServer < Net::Gurigoro::Kaiji::Poker::Poker::Service
  def create_new_game_room(req, _call)
    begin
      room = PokerRoom.create_room(req.usersId)
    rescue
      Net::Gurigoro::Kaiji::Poker::CreateNewGameRoomReply.new(isSucceed: false)
    else
      Net::Gurigoro::Kaiji::Poker::CreateNewGameRoomReply.new(
        isSucceed: true,
        gameRoomId: room.id
      )
    end
  end

  def call(req, _call)
    result = PokerPlayer.call(req.gameRoomId, req.userId)
    Net::Gurigoro::Kaiji::Poker::CallReply.new(
      result: result,
      userId: req.userId,
      nextPlayersAvailableActions: ActionChecker.poker_available_action(req.gameRoomId, req.userId)
    )
  end

  def raise(req, _call)
    result = PokerPlayer.raise(req.gameRoomId, req.userId, req.betPoints)
    Net::Gurigoro::Kaiji::Poker::RaiseReply.new(
      result: result,
      userId: req.userId,
      nextPlayersAvailableActions: ActionChecker.poker_available_action(req.gameRoomId, req.userId)
    )
  end

  def check(req, _call)
  end

  def fold(req, _call)
  end

  def set_players_cards(req, _call)
  end

  def get_game_result(req, _call)
  end

  def destroy_game_room(req, _call)
    begin
      PokerRoom.destroy_room(req.gameRoomId)
    rescue
      Net::Gurigoro::Kaiji::Poker::DestroyGameRoomReply.new(isSucceed: false)
    else
      Net::Gurigoro::Kaiji::Poker::DestroyGameRoomReply.new(isSucceed: true)
    end
  end
end
