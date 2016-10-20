require_relative './../protoc_ruby/poker_services_pb'
require_relative './database'

RSpec.describe 'PokerServer' do
  before :all do
    @stub = Net::Gurigoro::Kaiji::Poker::Poker::Stub.new('game-server:1257', :this_channel_is_insecure)
    (1..10).map do |x|
      User.create(id: x)
      if x > 8
        User.reduce_point(x, 9500)
      end
    end
  end

  it 'create new game room' do
    reply = @stub.create_new_game_room(Net::Gurigoro::Kaiji::Poker::CreateNewGameRoomRequest.new(
      accessToken: 'test',
      usersId: (1..10).map { |x| x }
    ))
    expect(reply.isSucceed).to eq true
    expect(PokerRoom.find_by_id(reply.gameRoomId).nil?).to eq false
  end

  it 'raise' do
    reply = @stub.raise(Net::Gurigoro::Kaiji::Poker::RaiseRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 1,
      betPoints: 600
    ))
    expect(reply.result).to eq :SUCCEED
    expect(reply.userId).to eq 1
    expect(reply.nextPlayersAvailableActions).to eq [:CALL, :RAISE, :FOLD, :OPEN_CARDS]

    reply = @stub.raise(Net::Gurigoro::Kaiji::Poker::RaiseRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 2,
      betPoints: 1_000_000
    ))
    expect(reply.result).to eq :NO_ENOUGH_POINTS
    expect(reply.userId).to eq 2
    expect(reply.nextPlayersAvailableActions).to eq [:CALL, :RAISE, :FOLD, :OPEN_CARDS]

    reply = @stub.raise(Net::Gurigoro::Kaiji::Poker::RaiseRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 3,
      betPoints: 100
    ))
    expect(reply.result).to eq :NOT_ENOUGH_TO_RAISE
    expect(reply.userId).to eq 3
    expect(reply.nextPlayersAvailableActions).to eq [:CALL, :RAISE, :FOLD, :OPEN_CARDS]
  end

  it 'call' do
    (2..9).each do |x|
      reply = @stub.call(Net::Gurigoro::Kaiji::Poker::CallRequest.new(
        accessToken: 'test',
        gameRoomId: PokerRoom.all.first.id,
        userId: x
      ))
      if x > 8
        expect(reply.result).to eq :SUCCEED
        expect(reply.nextPlayersAvailableActions).to eq [:CALL, :FOLD, :OPEN_CARDS]
        expect(User.where(id: x).first.points).to eq 1
      else
        expect(reply.result).to eq :SUCCEED
        expect(reply.nextPlayersAvailableActions).to eq [:CALL, :RAISE, :FOLD, :OPEN_CARDS]
        expect(User.where(id: x).first.points).to eq 9_400
      end
    end
  end

  it 'fold' do
    reply = @stub.fold(Net::Gurigoro::Kaiji::Poker::FoldRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 10
    ))
    expect(reply.isSucceed).to eq true
    expect(reply.nextPlayersAvailableActions).to eq [:OPEN_CARDS]
    expect(User.where(id: 10).first.points).to eq 300
  end

  it 'set players cards' do
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 1,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 1,
          number: 3
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 2,
          number: 5
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 3,
          number: 7
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 9
        )]
      )
    ))
    expect(reply.hand).to eq :HIGH_CARDS
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 2,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 1,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 2,
          number: 5
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 3,
          number: 7
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 9
        )]
      )
    ))
    expect(reply.hand).to eq :ONE_PAIR
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 3,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 1,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 2,
          number: 5
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 3,
          number: 5
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 9
        )]
      )
    ))
    expect(reply.hand).to eq :TWO_PAIRS
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 4,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 1,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 2,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 3,
          number: 7
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 9
        )]
      )
    ))
    expect(reply.hand).to eq :THREE_OF_A_KIND
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 5,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 2
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 1,
          number: 3
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 2,
          number: 4
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 3,
          number: 5
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 6
        )]
      )
    ))
    expect(reply.hand).to eq :STRAIGHT
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 6,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 3
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 5
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 7
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 9
        )]
      )
    ))
    expect(reply.hand).to eq :FLUSH
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 7,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 1,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 2,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 3,
          number: 7
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 7
        )]
      )
    ))
    expect(reply.hand).to eq :FULL_HOUSE
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 8,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 1,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 2,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 3,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 9
        )]
      )
    ))
    expect(reply.hand).to eq :FOUR_OF_A_KIND
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 9,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 2
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 3
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 4
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 5
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 6
        )]
      )
    ))
    expect(reply.hand).to eq :STRAIGHT_FLUSH
    reply = @stub.set_players_cards(Net::Gurigoro::Kaiji::Poker::SetPlayersCardsRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id,
      userId: 10,
      playerCards: Net::Gurigoro::Kaiji::TrumpCards.new(
        cards: [Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 1
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 13
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 12
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 11
        ),
        Net::Gurigoro::Kaiji::TrumpCard.new(
          suit: 0,
          number: 10
        )]
      )
    ))
    expect(reply.hand).to eq :ROYAL_STRAIGHT_FLUSH
  end

  it 'get game result' do
    reply = @stub.get_game_result(Net::Gurigoro::Kaiji::Poker::GetGameResultRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id
    ))
    reply.playerResults.sort_by! { |item| item.userId }
    expect(reply.playerResults[0].gameResult).to eq :LOSE
    expect(reply.playerResults[0].gotPoints).to eq 0
    expect(reply.playerResults[1].gameResult).to eq :LOSE
    expect(reply.playerResults[1].gotPoints).to eq 0
    expect(reply.playerResults[2].gameResult).to eq :LOSE
    expect(reply.playerResults[2].gotPoints).to eq 0
    expect(reply.playerResults[3].gameResult).to eq :LOSE
    expect(reply.playerResults[3].gotPoints).to eq 0
    expect(reply.playerResults[4].gameResult).to eq :LOSE
    expect(reply.playerResults[4].gotPoints).to eq 0
    expect(reply.playerResults[5].gameResult).to eq :LOSE
    expect(reply.playerResults[5].gotPoints).to eq 0
    expect(reply.playerResults[6].gameResult).to eq :LOSE
    expect(reply.playerResults[6].gotPoints).to eq 0
    expect(reply.playerResults[7].gameResult).to eq :LOSE
    expect(reply.playerResults[7].gotPoints).to eq 0
    expect(reply.playerResults[8].gameResult).to eq :WIN
    expect(reply.playerResults[8].gotPoints).to eq 10000
    expect(reply.playerResults[9].gameResult).to eq :LOSE
    expect(reply.playerResults[9].gotPoints).to eq 0
    expect(PokerPlayer.where(poker_room_id: PokerRoom.all.first.id, user_id: 9).first.all_in).to eq true
  end

  it 'destroy game room' do
    reply = @stub.destroy_game_room(Net::Gurigoro::Kaiji::Poker::DestroyGameRoomRequest.new(
      accessToken: 'test',
      gameRoomId: PokerRoom.all.first.id
    ))
    expect(reply.isSucceed).to eq true
    expect(Hand.all.blank?).to eq true
    expect(PokerPlayer.all.blank?).to eq true
    expect(PokerRoom.all.blank?).to eq true
  end

  after :all do
    User.where(id: (1..10).map { |x| x }).destroy_all
  end
end
