class Baccarat
  class << self
    def emulate
      action = []
      banker = []
      player = []
      decks = (0..3).map do |suit|
        (1..13).map do |number|
          { suit: suit, number: number }
        end
      end
      decks.flatten!
      2.times do
        card = decks.shuffle!.shift
        action.push(action: 'draw', side: 'player', card: card)
        player.push(card)
      end
      2.times do
        card = decks.shuffle!.shift
        action.push(action: 'draw', side: 'banker', card: card)
        banker.push(card)
      end
      player_points = PointCalculator.baccarat_hands_point(player)
      banker_points = PointCalculator.baccarat_hands_point(banker)
      if player_points >= 8 || banker_points >= 8
        action.push(action: 'result', winner: 2) if player_points == banker_points
        action.push(action: 'result', winner: 1) if player_points < banker_points
        action.push(action: 'result', winner: 0) if player_points > banker_points
        return action
      elsif [6, 7].include?(player_points) && [6, 7].include?(banker_points)
        action.push(action: 'result', winner: 2) if player_points == banker_points
        action.push(action: 'result', winner: 1) if player_points < banker_points
        action.push(action: 'result', winner: 0) if player_points > banker_points
        return action
      end
      if player_points <= 5
        card = decks.shuffle!.shift
        action.push(action: 'draw', side: 'player', card: card)
        player.push(card)
      end
      if banker_draw?(banker_points, player)
        card = decks.shuffle!.shift
        action.push(action: 'draw', side: 'banker', card: card)
        banker.push(card)
      end
      player_points = PointCalculator.baccarat_hands_point(player)
      banker_points = PointCalculator.baccarat_hands_point(banker)
      action.push(action: 'result', winner: 2) if player_points == banker_points
      action.push(action: 'result', winner: 1) if player_points < banker_points
      action.push(action: 'result', winner: 0) if player_points > banker_points
      action
    end

    def banker_draw?(banker_points, player_cards)
      return true if player_cards.length < 3 && banker_points < 6
      case banker_points
      when 0..1, 9 then banker_points < 4
      when 2..3 then banker_points < 5
      when 4..5 then banker_points < 6
      when 6..7 then banker_points < 7
      when 8 then banker_points < 3
      end
    end
  end
end
