class User < ActiveRecord::Base
  self.primary_key = 'id'

  class << self
    def add(id, params = {})
      user = User.new params.merge(id: id)
      user.save
    end

    def modify(id, params = {})
      user = User.find_by_id(id)
      return false if user.blank?
      user.update(params)
    end

    def add_point(id, points)
      user = User.find_by_id(id)
      return false if user.blank?
      points_balance = user.points
      user.update(points: points_balance + points)
    end

    def has_points?(id, points)
      points < User.find_by_id(id).points
    end

    def reduce_point(id, points)
      user = User.find_by_id(id)
      points_balance = user.points
      if points_balance - points <= 0
        user.update(points: 10_000, continue_count: user.continue_count + 1)
      else
        user.update(points: points_balance - points)
      end
    end
  end
end
