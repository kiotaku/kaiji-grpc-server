require_relative './../protoc_ruby/blackjack_services_pb'

class BlackjackServer < Net::Gurigoro::Kaiji::BlackJack::Service
  def create_new_game_room
  end

  def betting
  end

  def set_first_dealed_cards
  end

  def set_first_dealers_card
  end

  def hit
  end

  def stand
  end

  def split
  end

  def double_down
  end

  def set_next_dealers_card
  end

  def get_game_result
  end

  def destroy_game_room
  end
end
