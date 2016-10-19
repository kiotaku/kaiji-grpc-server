require_relative './../util/point_calculator'

RSpec.describe 'PointCalculator' do
  it 'compare_point_and_hands' do
    user_hands = [[0, 1], [0, 10]]
    dealer_hands = [[0, 1], [0, 11]]
    result = PointCalculator.compare_point_and_hands(
      PointCalculator.blackjack_card_points(user_hands),
      user_hands,
      PointCalculator.blackjack_card_points(dealer_hands),
      dealer_hands
    )
    expect(result).to eq :TIE

    user_hands = [[0, 8], [0, 3], [0, 10]]
    dealer_hands = [[0, 1], [0, 11]]
    result = PointCalculator.compare_point_and_hands(
      PointCalculator.blackjack_card_points(user_hands),
      user_hands,
      PointCalculator.blackjack_card_points(dealer_hands),
      dealer_hands
    )
    expect(result).to eq :LOSE

    user_hands = [[0, 1], [0, 10]]
    dealer_hands = [[0, 9], [0, 2], [0, 11]]
    result = PointCalculator.compare_point_and_hands(
      PointCalculator.blackjack_card_points(user_hands),
      user_hands,
      PointCalculator.blackjack_card_points(dealer_hands),
      dealer_hands
    )
    expect(result).to eq :WIN_BLACKJACK

    user_hands = [[0,  9], [0, 10]]
    dealer_hands = [[0, 9], [0, 11]]
    result = PointCalculator.compare_point_and_hands(
      PointCalculator.blackjack_card_points(user_hands),
      user_hands,
      PointCalculator.blackjack_card_points(dealer_hands),
      dealer_hands
    )
    expect(result).to eq :TIE

    user_hands = [[0, 4], [0, 10]]
    dealer_hands = [[0, 7], [0, 11]]
    result = PointCalculator.compare_point_and_hands(
      PointCalculator.blackjack_card_points(user_hands),
      user_hands,
      PointCalculator.blackjack_card_points(dealer_hands),
      dealer_hands
    )
    expect(result).to eq :LOSE

    user_hands = [[0, 8], [0, 10]]
    dealer_hands = [[0, 7], [0, 11]]
    result = PointCalculator.compare_point_and_hands(
      PointCalculator.blackjack_card_points(user_hands),
      user_hands,
      PointCalculator.blackjack_card_points(dealer_hands),
      dealer_hands
    )
    expect(result).to eq :WIN

    user_hands = [[0, 2], [0, 10]]
    dealer_hands = [[0, 7], [0, 11], [0, 6]]
    result = PointCalculator.compare_point_and_hands(
      PointCalculator.blackjack_card_points(user_hands),
      user_hands,
      PointCalculator.blackjack_card_points(dealer_hands),
      dealer_hands
    )
    expect(result).to eq :WIN
  end
end
