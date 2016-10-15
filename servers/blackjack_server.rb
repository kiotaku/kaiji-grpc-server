require_relative './../protoc_ruby/blackjack_services_pb'

class BlackjackServer < Net::Gurigoro::Kaiji::Blackjack::BlackJack::Service
  def create_new_game_room(req, _call)
    begin
      room = BlackjackRoom.create_room(req.usersId)
    rescue
      Net::Gurigoro::Kaiji::Blackjack::CreateNewGameRoomReply.new isSucceed: false
    end
    Net::Gurigoro::Kaiji::Blackjack::CreateNewGameRoomReply.new isSucceed: true,
                                                                gameRoomId: room.id
  end

  def betting(req, _call)
  end

  def set_first_dealed_cards(req, _call)
  end

  def set_first_dealers_card(req, _call)
  end

  def hit(req, _call)
  end

  def stand(req, _call)
  end

  def split(req, _call)
  end

  def double_down(req, _call)
  end

  def set_next_dealers_card(req, _call)
  end

  def get_game_result(req, _call)
  end

  def destroy_game_room(req, _call)
    begin
      BlackjackRoom.destroy_room(req.gameRoomId)
    rescue
      Net::Gurigoro::Kaiji::Blackjack::DestroyGameRoomReply.new isSucceed: false
    end
    Net::Gurigoro::Kaiji::Blackjack::DestroyGameRoomReply.new isSucceed: true
  end
end
