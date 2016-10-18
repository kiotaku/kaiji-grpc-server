require_relative './../protoc_ruby/Baccarat_services_pb'
require_relative './database'

RSpec.describe 'BaccaratServer' do
  before :all do
    @stub = Net::Gurigoro::Kaiji::Baccarat::Baccarat::Stub.new('game-server:1257', :this_channel_is_insecure)
    (1..10).map do |x|
      User.create(id: x)
    end
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

    (1..10).each do |x|
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
