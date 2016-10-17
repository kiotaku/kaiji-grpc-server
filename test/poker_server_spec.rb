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
    reply = @stub.create_new_game_room(Net::Gurigoro::Kaiji::Blackjack::CreateNewGameRoomRequest.new(
      accessToken: 'test',
      usersId: (1..10).map { |x| x }
    ))
    expect(reply.isSucceed).to eq true
    expect(PokerRoom.find_by_id(reply.gameRoomId).nil?).to eq false
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
