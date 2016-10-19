require_relative './database'
require_relative './../model/user'

RSpec.describe 'User model' do
  it 'add' do
    User.add(1)
    expect(User.all.first.id).to eq 1
  end

  it 'reduce point' do
    User.reduce_point(User.all.first.id, 20_000)
    user = User.all.first
    expect(user.points).to eq 10_000
    expect(user.continue_count).to eq 1
  end

  after :all do
    User.all.destroy_all
  end
end
