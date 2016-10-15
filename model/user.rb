class User < ActiveRecord::Base
  belongs_to :blackjack_room, foreign_key: user_id

  def self.add(id, params = {})
    user = User.new params.merge(id: id)
    user.save
  end

  def self.modify(id, params = {})
    User.find(id).update(params)
  end
end
