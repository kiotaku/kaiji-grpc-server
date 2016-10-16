require_relative './../protoc_ruby/kaiji_services_pb'
require_relative './database'

RSpec.describe 'KaijiServer' do
  before :all do
    @stub = Net::Gurigoro::Kaiji::Kaiji::Stub.new('game-server:1257', :this_channel_is_insecure)
  end

  it 'add user' do
    reply = @stub.add_user(Net::Gurigoro::Kaiji::AddUserRequest.new(
      accessToken: 'test',
      userId: 10,
      name: 'test',
      isAvailable: true,
      isAnonymous: true
    ))
    expect(reply.isSucceed).to eq true
    expect(reply.userId).to eq 10

    user = User.find(10)
    expect(user.id).to eq 10
    expect(user.name).to eq 'test'
    expect(user.points).to eq 10_000
    expect(user.is_available).to eq true
    expect(user.is_anonymous).to eq true
    expect(user.continue_count).to eq 0
  end

  it 'get user by id' do
    reply = @stub.get_user_by_id(Net::Gurigoro::Kaiji::GetUserByIdRequest.new(
      accessToken: 'test',
      userId: 10
    ))
    expect(reply.isFound).to eq true

    user = User.find(10)
    expect(user.id).to eq reply.userId
    expect(user.name).to eq reply.name
    expect(user.points).to eq reply.point
    expect(user.is_available).to eq reply.isAvailable
    expect(user.is_anonymous).to eq reply.isAnonymous
    expect(user.continue_count).to eq reply.continueCount
  end

  it 'not found get user by id' do
    reply = @stub.get_user_by_id(Net::Gurigoro::Kaiji::GetUserByIdRequest.new(
      accessToken: 'test',
      userId: 20
    ))
    expect(reply.isFound).to eq false
  end

  it 'modify user' do
    reply = @stub.modify_user(Net::Gurigoro::Kaiji::ModifyUserRequest.new(
      accessToken: 'test',
      userId: 10,
      name: 'user',
      isAvailable: false,
      isAnonymous: false
    ))
    expect(reply.isSucceed).to eq true
    expect(reply.userId).to eq 10

    user = User.find(10)
    expect(user.id).to eq 10
    expect(user.name).to eq 'user'
    expect(user.points).to eq 10_000
    expect(user.is_available).to eq false
    expect(user.is_anonymous).to eq false
    expect(user.continue_count).to eq 0
  end

  it 'not found modify user' do
    reply = @stub.modify_user(Net::Gurigoro::Kaiji::ModifyUserRequest.new(
      accessToken: 'test',
      userId: 20,
      name: 'user',
      isAvailable: true,
      isAnonymous: true
    ))
    expect(reply.isSucceed).to eq false
  end

  after :all do
    User.where(id: 10).destroy_all
  end
end
