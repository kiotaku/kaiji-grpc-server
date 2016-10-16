require_relative './../protoc_ruby/blackjack_services_pb'
require_relative './database'

RSpec.describe 'KaijiServer' do
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
