require_relative './../protoc_ruby/blackjack_services_pb'
require_relative './database'

RSpec.describe 'BlackjackServer' do
  before :all do
    @stub = Net::Gurigoro::Kaiji::Blackjack::BlackJack::Stub.new('game-server:1257', :this_channel_is_insecure)
    (1..10).map do |x|
      User.create(id: x)
    end
    @bettingResult = {
      SUCCEED: 0,
      NO_ENOUGH_POINTS: 1,
      ALREADY_BETTED: 2,
      UNKNOWN_FAILED: 3
    }
    @player_action = {
      UNKNOWN: 0,
      HIT: 1,
      STAND: 2,
      SPLIT: 3,
      DOUBLEDOWN: 4
    }
  end

  it 'create new game room' do
    reply = @stub.create_new_game_room(Net::Gurigoro::Kaiji::Blackjack::CreateNewGameRoomRequest.new(
      accessToken: 'test',
      usersId: (1..10).map { |x| x }
    ))
    expect(reply.isSucceed).to eq true
    expect(BlackjackRoom.find_by_id(reply.gameRoomId).nil?).to eq false
  end

  it 'betting no enough points' do
    reply = @stub.betting(Net::Gurigoro::Kaiji::Blackjack::BettingRequest.new(
    accessToken: 'test',
    gameRoomId: BlackjackRoom.all.first.id,
    userId: 1,
    betPoints: 11_000
    ))
    expect(@bettingResult[reply.result]).to eq 1
  end

  it 'betting success' do
    (1..10).each do |x|
      reply = @stub.betting(Net::Gurigoro::Kaiji::Blackjack::BettingRequest.new(
        accessToken: 'test',
        gameRoomId: BlackjackRoom.all.first.id,
        userId: x,
        betPoints: 100
      ))
      expect(@bettingResult[reply.result]).to eq 0
    end
    User.where(id: (1..10).map { |x| x }).each do |user|
      expect(user.points).to eq 9900
    end
  end

  it 'betting already betted' do
    reply = @stub.betting(Net::Gurigoro::Kaiji::Blackjack::BettingRequest.new(
    accessToken: 'test',
    gameRoomId: BlackjackRoom.all.first.id,
    userId: 1,
    betPoints: 100
    ))
    expect(@bettingResult[reply.result]).to eq 2
  end

  it 'set first dealed cards' do
    reply = @stub.set_first_dealed_cards(Net::Gurigoro::Kaiji::Blackjack::SetFirstDealedCardsRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      playerCards: (1..10).map do |x|
        if x == 10
          Net::Gurigoro::Kaiji::Blackjack::FirstDealPlayerCards.new(
            userId: x,
            cards: Net::Gurigoro::Kaiji::TrumpCards.new(
              cards: [2, 2].map do |num|
                Net::Gurigoro::Kaiji::TrumpCard.new(
                    suit: 0,
                    number: num
                )
              end
            )
          )
        elsif x == 8
          Net::Gurigoro::Kaiji::Blackjack::FirstDealPlayerCards.new(
            userId: x,
            cards: Net::Gurigoro::Kaiji::TrumpCards.new(
              cards: [1, 13].map do |num|
                Net::Gurigoro::Kaiji::TrumpCard.new(
                    suit: 0,
                    number: num
                )
              end
            )
          )
        else
          Net::Gurigoro::Kaiji::Blackjack::FirstDealPlayerCards.new(
            userId: x,
            cards: Net::Gurigoro::Kaiji::TrumpCards.new(
              cards: [3, 13].map do |num|
                Net::Gurigoro::Kaiji::TrumpCard.new(
                    suit: 0,
                    number: num
                )
              end
            )
          )
        end
      end
    ))
    expect(Hand.all.count).to eq 20
  end

  it 'set first dealers card' do
    reply = @stub.set_first_dealers_card(Net::Gurigoro::Kaiji::Blackjack::SetFirstDealersCardRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      card: Net::Gurigoro::Kaiji::TrumpCard.new(
        suit: 0,
        number: 6
      )
    ))
    expect(Hand.where(
      hands_id: BlackjackRoom.all.first.dealer_hands_id
    ).pluck(:suit, :number)).to eq [[0, 6]]
  end

  it 'hit and bust' do
    reply = @stub.hit(Net::Gurigoro::Kaiji::Blackjack::HitRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      userId: 1,
      card: Net::Gurigoro::Kaiji::TrumpCard.new(
        suit: 0,
        number: 9
      ),
      handsIndex: 0
    ))
    expect(reply.isBusted).to eq true
    expect(reply.cardPoints).to eq 22
    expect(reply.allowedActions.blank?).to eq true
  end

  it 'hit' do
    reply = @stub.hit(Net::Gurigoro::Kaiji::Blackjack::HitRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      userId: 2,
      card: Net::Gurigoro::Kaiji::TrumpCard.new(
        suit: 0,
        number: 6
      ),
      handsIndex: 0
    ))
    expect(reply.isBusted).to eq false
    expect(reply.cardPoints).to eq 19
    expect(reply.allowedActions.map { |e| @player_action[e] }).to eq [1, 2]
  end

  it 'stand' do
    reply = @stub.stand(Net::Gurigoro::Kaiji::Blackjack::StandRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      userId: 2,
      handsIndex: 0
    ))
    expect(reply.isSucceed).to eq true
    expect(Hand.is_stand?(
      BlackjackPlayer.find_in_room(BlackjackRoom.all.first.id, 2).hands_id_first
    )).to eq true
  end

  it 'split' do
    reply = @stub.split(Net::Gurigoro::Kaiji::Blackjack::SplitRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      userId: 10
    ))
    expect(reply.isSucceed).to eq true
    expect(BlackjackPlayer.user_hands_split?(BlackjackRoom.all.first.id, 10)).to eq true
    expect(BlackjackPlayer.where(
      blackjack_room_id: BlackjackRoom.all.first.id,
      user_id: 10
      ).first.bet_points).to eq 200
    expect(User.find_by_id(10).points).to eq 9800
  end

  it 'double down' do
    reply = @stub.double_down(Net::Gurigoro::Kaiji::Blackjack::DoubleDownRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      userId: 9,
      card: Net::Gurigoro::Kaiji::TrumpCard.new(
        suit: 0,
        number: 8
      )
    ))
    expect(reply.cardPoints).to eq 21
    expect(BlackjackPlayer.find_in_room(BlackjackRoom.all.first.id, 9).is_double_down).to eq true
  end

  it 'next dealers card' do
    reply = @stub.set_next_dealers_card(Net::Gurigoro::Kaiji::Blackjack::SetNextDealersCardRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      card: Net::Gurigoro::Kaiji::TrumpCard.new(
        suit: 0,
        number: 8
      )
    ))
    expect(reply.cardPoints).to eq 14
    expect(reply.shouldHit).to eq true
    reply = @stub.set_next_dealers_card(Net::Gurigoro::Kaiji::Blackjack::SetNextDealersCardRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id,
      card: Net::Gurigoro::Kaiji::TrumpCard.new(
        suit: 0,
        number: 8
      )
    ))
    expect(reply.cardPoints).to eq 22
    expect(reply.shouldHit).to eq false
    expect(reply.isBusted).to eq true
  end

  it 'game result' do
    reply = @stub.get_game_result(Net::Gurigoro::Kaiji::Blackjack::GetGameResultRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id
    ))
    expect(reply.playerResults[0].gameResult).to eq :LOSE
    expect(User.find_by_id(1).points).to eq 9_900
    expect(User.find_by_id(2).points).to eq 10_100
    expect(User.find_by_id(8).points).to eq 10_200
    expect(User.find_by_id(9).points).to eq 10_200
    expect(User.find_by_id(10).points).to eq 10_200
  end

  it 'destroy game room' do
    reply = @stub.destroy_game_room(Net::Gurigoro::Kaiji::Blackjack::DestroyGameRoomRequest.new(
      accessToken: 'test',
      gameRoomId: BlackjackRoom.all.first.id
    ))
    expect(reply.isSucceed).to eq true
    expect(Hand.all.blank?).to eq true
    expect(BlackjackPlayer.all.blank?).to eq true
    expect(BlackjackRoom.all.blank?).to eq true
  end

  after :all do
    User.where(id: (1..10).map { |x| x }).destroy_all
  end
end
