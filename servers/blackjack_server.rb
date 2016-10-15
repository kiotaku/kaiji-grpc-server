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

  def betting
  end

  def set_first_dealed_cards
  end

  def set_first_dealers_card
  end

  def hit
  end

  def stand
  end

  def split
  end

  def double_down
  end

  def set_next_dealers_card
  end

  def get_game_result
  end

  def destroy_game_room
  end
end
