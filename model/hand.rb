class Hand < ActiveRecord::Base
  class << self
    def delete_hands(hands_id)
      Hand.destroy_all(hands_id: hands_id)
    end
  end
end
