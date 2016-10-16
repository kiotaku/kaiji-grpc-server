require_relative './../protoc_ruby/blackjack_services_pb'
require_relative './database'

RSpec.describe 'KaijiServer' do
  before :all do
    @stub = Net::Gurigoro::Kaiji::Blackjack::BlackJack::Stub.new('game-server:1257', :this_channel_is_insecure)
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
