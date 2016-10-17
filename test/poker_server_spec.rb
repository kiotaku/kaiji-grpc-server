require_relative './../protoc_ruby/poker_services_pb'
require_relative './database'

RSpec.describe 'PokerServer' do
  before :all do
    @stub = Net::Gurigoro::Kaiji::Poker::Poker::Stub.new('game-server:1257', :this_channel_is_insecure)
    (1..10).map do |x|
      User.create(id: x)
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
      betPoints: 200
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
      expect(reply.result).to eq :SUCCEED
      expect(reply.nextPlayersAvailableActions).to eq [:CALL, :RAISE, :FOLD, :OPEN_CARDS]
      expect(User.where(id: x).first.points).to eq 9_800
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
    expect(User.where(id: 10).first.points).to eq 9_800
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
