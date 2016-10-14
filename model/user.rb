class User < ActiveRecord::Base
  belongs_to :blackjack_room, foreign_key: user_id

  def add(id, params = {})
    user = User.new params.merge(id: id)
    user.save!
  end

  def modify(id, params = {})
    User.find(id: id).update(params)
  end
end
