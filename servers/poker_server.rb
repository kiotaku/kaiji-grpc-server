require_relative './../protoc_ruby/poker_services_pb'

class PokerServer < Net::Gurigoro::Kaiji::Poker::Poker::Service
  def create_new_game_room(req, _call)
  end

  def bet(req, _call)
  end

  def call(req, _call)
  end

  def raise(req, _call)
  end

  def check(req, _call)
  end

  def fold(req, _call)
  end

  def set_players_cards(req, _call)
  end

  def get_game_result(req, _call)
  end

  def destroy_game_room(req, _call)
  end
end
