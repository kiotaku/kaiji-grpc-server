require_relative './../protoc_ruby/point_services_pb'
require_relative './../protoc_ruby/kaiji_services_pb'
require_relative './database'

RSpec.describe 'PointServer' do
  before :all do
    @stub = Net::Gurigoro::Kaiji::Point::Stub.new('game-server:1257', :this_channel_is_insecure)
    Net::Gurigoro::Kaiji::Kaiji::Stub.new('game-server:1257', :this_channel_is_insecure).add_user(
      Net::Gurigoro::Kaiji::AddUserRequest.new(
        accessToken: 'test',
        userId: 10,
        name: 'test',
        isAvailable: true,
        isAnonymous: true
      )
    )
  end

  it 'add point' do
    reply = @stub.add_point(Net::Gurigoro::Kaiji::AddPointRequest.new(
      accessToken: 'test',
      userId: 10,
      addPoints: 1000,
      reason: 'win blackjack'
    ))
    expect(reply.isSucceed).to eq true
    expect(reply.userId).to eq 10
    expect(reply.addedPoints).to eq 1000
    expect(reply.pointBalance).to eq 11_000
  end

  it 'not found user in add point' do
    reply = @stub.add_point(Net::Gurigoro::Kaiji::AddPointRequest.new(
      accessToken: 'test',
      userId: 20,
      addPoints: 1000,
      reason: 'win blackjack'
    ))
    expect(reply.isSucceed).to eq false
  end

  it 'get point balance' do
    reply = @stub.get_point_balance(Net::Gurigoro::Kaiji::GetPointBalanceRequest.new(
      accessToken: 'test',
      userId: 10
    ))
    expect(reply.isSucceed).to eq true
    expect(reply.userId).to eq 10
    expect(reply.pointBalance).to eq 11_000
  end

  it 'not found user in get point balance' do
    reply = @stub.get_point_balance(Net::Gurigoro::Kaiji::GetPointBalanceRequest.new(
      accessToken: 'test',
      userId: 20
    ))
    expect(reply.isSucceed).to eq false
  end

  after :all do
    User.where(id: 10).destroy_all
  end
end
