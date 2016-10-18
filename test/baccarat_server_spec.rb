require_relative './../protoc_ruby/Baccarat_services_pb'
require_relative './database'

RSpec.describe 'BaccaratServer' do
  before :all do
    @stub = Net::Gurigoro::Kaiji::Baccarat::Baccarat::Stub.new('game-server:1257', :this_channel_is_insecure)
    (1..10).map do |x|
      User.create(id: x)
    end
    @bet_side = {
      PLAYER: 0,
      BANKER: 1,
      TIE: 2
    }
    @won_side = 0
  end

  it 'create new game room' do
    reply = @stub.create_new_game_room(Net::Gurigoro::Kaiji::Baccarat::CreateNewGameRoomRequest.new(
      accessToken: 'test',
      usersId: (1..10).map { |x| x }
    ))
    expect(reply.isSucceed).to eq true
    expect(BaccaratRoom.find_by_id(reply.gameRoomId).nil?).to eq false
  end

  it 'bet' do
    reply = @stub.bet(Net::Gurigoro::Kaiji::Baccarat::BetRequest.new(
      accessToken: 'test',
      gameRoomId: BaccaratRoom.all.first.id,
      userId: 1,
      betPoints: 1_000_000,
      bettingSide: 0
    ))
    expect(reply.result).to eq :NO_ENOUGH_POINTS

    (1..9).each do |x|
      reply = @stub.bet(Net::Gurigoro::Kaiji::Baccarat::BetRequest.new(
        accessToken: 'test',
        gameRoomId: BaccaratRoom.all.first.id,
        userId: x,
        betPoints: 1000,
        bettingSide: x % 3
      ))
      expect(reply.result).to eq :SUCCEED
    end
  end

  it 'start opening cards' do
    reply = @stub.start_opening_cards(Net::Gurigoro::Kaiji::Baccarat::StartOpeningCardsRequest.new(
      accessToken: 'test',
      gameRoomId: BaccaratRoom.all.first.id
    ))
    expect(reply.result).to eq :NOT_ALL_USERS_BETTED_YET

    @stub.bet(Net::Gurigoro::Kaiji::Baccarat::BetRequest.new(
      accessToken: 'test',
      gameRoomId: BaccaratRoom.all.first.id,
      userId: 10,
      betPoints: 1000,
      bettingSide: 10 % 3
    ))

    reply = @stub.start_opening_cards(Net::Gurigoro::Kaiji::Baccarat::StartOpeningCardsRequest.new(
      accessToken: 'test',
      gameRoomId: BaccaratRoom.all.first.id
    ))
    expect(reply.result).to eq :SUCCEED
    @won_side = @bet_side[reply.wonSide]
  end

  it 'get game result' do
    game_results = {
      0 => :LOSE,
      1 => :WIN,
      2 => :WIN_WITH_BETTING_TIE
    }
    reply = @stub.get_game_result(Net::Gurigoro::Kaiji::Baccarat::GetGameResultRequest.new(
      accessToken: 'test',
      gameRoomId: BaccaratRoom.all.first.id
    ))
    expect(reply.result).to eq :SUCCEED
    reply.playerResults.each do |result|
      id = result.userId
      game_result = id % 3 == @won_side ? 1 : @won_side == 2 ? 2 : 0
      expect(result.gameResult).to eq game_results[game_result]
      got_points = 0 if game_result.zero?
      got_points = 1000 if game_result == 2
      got_points = 2000 if game_result == 1
      got_points = 10_000 if game_result == 1 && id % 3 == 2
      expect(result.gotPoints).to eq got_points
    end
  end

  it 'destroy game room' do
    reply = @stub.destroy_game_room(Net::Gurigoro::Kaiji::Baccarat::DestroyGameRoomRequest.new(
      accessToken: 'test',
      gameRoomId: BaccaratRoom.all.first.id
    ))
    expect(reply.isSucceed).to eq true
    expect(BaccaratPlayer.all.blank?).to eq true
    expect(BaccaratRoom.all.blank?).to eq true
  end

  after :all do
    User.where(id: (1..10).map { |x| x }).destroy_all
  end
end
