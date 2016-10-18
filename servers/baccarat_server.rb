require_relative './../protoc_ruby/Baccarat_services_pb'

class BaccaratServer < Net::Gurigoro::Kaiji::Baccarat::Baccarat::Service
  def create_new_game_room(req, _call)
    begin
      room = BaccaratRoom.create_room(req.usersId)
    rescue
      Net::Gurigoro::Kaiji::Baccarat::CreateNewGameRoomReply.new(isSucceed: false)
    else
      Net::Gurigoro::Kaiji::Baccarat::CreateNewGameRoomReply.new(
        isSucceed: true,
        gameRoomId: room.id
      )
    end
  end

  def bet(req, _call)
    result = BaccaratPlayer.bet(req.gameRoomId, req.userId, req.betPoints, req.bettingSide)
    Net::Gurigoro::Kaiji::Baccarat::BetReply.new(
      result: result,
      userId: req.userId
    )
  end

  def start_opening_cards(req, _call)
    result = BaccaratRoom.start_opening_cards(req.gameRoomId)
    Net::Gurigoro::Kaiji::Baccarat::StartOpeningCardsReply.new(
      result: result,
      wonSide: BaccaratRoom.find_by_id(req.gameRoomId).result % 3
    )
  end

  def get_game_result(req, _call)
    results = BaccaratRoom.game_results(req.gameRoomId)
    Net::Gurigoro::Kaiji::Baccarat::GetGameResultReply.new(
      result: results[:result],
      playerResults: results[:playerResults].map do |result|
        Net::Gurigoro::Kaiji::Baccarat::PlayerResult.new(result)
      end
    )
  end

  def destroy_game_room(req, _call)
    begin
      BaccaratRoom.destroy_room(req.gameRoomId)
    rescue
      Net::Gurigoro::Kaiji::Baccarat::DestroyGameRoomReply.new(isSucceed: false)
    else
      Net::Gurigoro::Kaiji::Baccarat::DestroyGameRoomReply.new(isSucceed: true)
    end
  end
end
