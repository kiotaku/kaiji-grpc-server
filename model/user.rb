class User < ActiveRecord::Base
  class << self
    def add(id, params = {})
      user = User.new params.merge(id: id)
      user.save
    end

    def modify(id, params = {})
      User.find(id).update(params)
    end

    def add_point(id, points)
      user = User.find(id)
      points_balance = user.points
      user.update(points: points_balance + points)
    end
  end
end
