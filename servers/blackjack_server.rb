require_relative './../protoc_ruby/blackjack_services_pb'

class BlackjackServer < Net::Gurigoro::Kaiji::Blackjack::BlackJack::Service
  def create_new_game_room(req, _call)
    begin
      room = BlackjackRoom.create_room(req.usersId)
    rescue
      Net::Gurigoro::Kaiji::Blackjack::CreateNewGameRoomReply.new isSucceed: false
    else
      Net::Gurigoro::Kaiji::Blackjack::CreateNewGameRoomReply.new(
        isSucceed: true,
        gameRoomId: room.id
      )
    end
  end

  def betting(req, _call)
    Net::Gurigoro::Kaiji::Blackjack::BettingReply.new(
      result: BlackjackRoom.betting(req.gameRoomId, req.userId, req.betPoints),
      userId: req.userId
    )
  end

  def set_first_dealed_cards(req, _call)
    req.playerCards.each do |player_card|
      BlackjackPlayer.add_user_hand(req.gameRoomId,
                                    player_card.usersId,
                                    player_card.cards,
                                    false)
    end
    Net::Gurigoro::Kaiji::Blackjack::SetFirstDealedCardsReply.new(
      isSucceed: true,
      actions: Net::Gurigoro::Kaiji::Blackjack::AllowedPlayerActions.new(
        BlackjackPlayer.can_user_action?
      )
    )
  end

  def set_first_dealers_card(req, _call)
    BlackjackRoom.add_dealer_hand(req.gameRoomId, req.card)
    Net::Gurigoro::Kaiji::Blackjack::SetFirstDealersCardReply.new(
      isSucceed: true
    )
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
    rescue => e
      p e
      Net::Gurigoro::Kaiji::Blackjack::DestroyGameRoomReply.new isSucceed: false
    else
      Net::Gurigoro::Kaiji::Blackjack::DestroyGameRoomReply.new isSucceed: true
    end
  end
end
