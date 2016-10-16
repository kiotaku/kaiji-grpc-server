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
      player_card.cards.cards.each do |card|
        BlackjackPlayer.add_user_hand(req.gameRoomId,
                                      player_card.userId,
                                      card,
                                      false)
      end
    end
    user_actions = BlackjackPlayer.can_user_first_action?(req.gameRoomId)
    Net::Gurigoro::Kaiji::Blackjack::SetFirstDealedCardsReply.new(
      isSucceed: true,
      actions: user_actions.map do |action|
        Net::Gurigoro::Kaiji::Blackjack::AllowedPlayerActions.new(
          userId: action[:userId],
          cardPoints: action[:cardPoints],
          actions: action[:actions]
        )
      end
    )
  end

  def set_first_dealers_card(req, _call)
    BlackjackRoom.add_dealer_hand(req.gameRoomId, req.card)
    Net::Gurigoro::Kaiji::Blackjack::SetFirstDealersCardReply.new(
      isSucceed: true
    )
  end

  def hit(req, _call)
    BlackjackPlayer.add_user_hand(
      req.gameRoomId,
      req.userId,
      req.card,
      !req.handsIndex.zero?
    )
    Net::Gurigoro::Kaiji::Blackjack::HitReply.new(
      isSucceed: true,
      userId: req.userId,
      isBusted: BlackjackPlayer.user_hands_busted?(
        req.gameRoomId,
        req.userId,
        !req.handsIndex.zero?
      ),
      cardPoints: BlackjackPlayer.user_hands_point(
        req.gameRoomId,
        req.userId,
        !req.handsIndex.zero?
      ),
      allowedActions: BlackjackPlayer.can_user_action?(
        req.gameRoomId,
        req.userId,
        !req.handsIndex.zero?
      )
    )
  end

  def stand(req, _call)
    result = BlackjackPlayer.user_hands_stand(
      req.gameRoomId,
      req.userId,
      !req.handsIndex.zero?
    )
    Net::Gurigoro::Kaiji::Blackjack::StandReply.new(isSucceed: !result.zero?)
  end

  def split(req, _call)
    result = BlackjackPlayer.user_hands_split(req.gameRoomId, req.userId)
    Net::Gurigoro::Kaiji::Blackjack::SplitReply.new(isSucceed: result)
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
    else
      Net::Gurigoro::Kaiji::Blackjack::DestroyGameRoomReply.new isSucceed: true
    end
  end
end
