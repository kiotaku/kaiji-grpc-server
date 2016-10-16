# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: poker.proto

require 'google/protobuf'

require_relative './trump_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "net.gurigoro.kaiji.poker.CreateNewGameRoomRequest" do
    optional :accessToken, :string, 1
    repeated :usersId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.poker.CreateNewGameRoomReply" do
    optional :isSucceed, :bool, 1
    optional :gameRoomId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.poker.BetRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
    optional :betPoints, :int64, 4
  end
  add_message "net.gurigoro.kaiji.poker.BetReply" do
    optional :result, :enum, 1, "net.gurigoro.kaiji.poker.BettingResult"
    optional :userId, :int64, 2
    repeated :nextPlayersAvailableActions, :enum, 3, "net.gurigoro.kaiji.poker.PlayerAction"
  end
  add_message "net.gurigoro.kaiji.poker.CallRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
  end
  add_message "net.gurigoro.kaiji.poker.CallReply" do
    optional :result, :enum, 1, "net.gurigoro.kaiji.poker.BettingResult"
    optional :userId, :int64, 2
    repeated :nextPlayersAvailableActions, :enum, 4, "net.gurigoro.kaiji.poker.PlayerAction"
  end
  add_message "net.gurigoro.kaiji.poker.RaiseRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
    optional :betPoints, :int64, 4
  end
  add_message "net.gurigoro.kaiji.poker.RaiseReply" do
    optional :result, :enum, 1, "net.gurigoro.kaiji.poker.BettingResult"
    optional :userId, :int64, 2
    repeated :nextPlayersAvailableActions, :enum, 3, "net.gurigoro.kaiji.poker.PlayerAction"
  end
  add_message "net.gurigoro.kaiji.poker.CheckRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
  end
  add_message "net.gurigoro.kaiji.poker.CheckReply" do
    optional :isSucceed, :bool, 1
    repeated :nextPlayersAvailableActions, :enum, 4, "net.gurigoro.kaiji.poker.PlayerAction"
  end
  add_message "net.gurigoro.kaiji.poker.FoldRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
  end
  add_message "net.gurigoro.kaiji.poker.FoldReply" do
    optional :isSucceed, :bool, 1
    optional :userId, :int64, 2
    repeated :nextPlayersAvailableActions, :enum, 3, "net.gurigoro.kaiji.poker.PlayerAction"
  end
  add_message "net.gurigoro.kaiji.poker.SetPlayersCardsRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
    optional :playerCards, :message, 4, "net.gurigoro.kaiji.TrumpCards"
  end
  add_message "net.gurigoro.kaiji.poker.SetPlayersCardsReply" do
    optional :isSucceed, :bool, 1
    optional :userId, :int64, 2
    optional :hand, :enum, 3, "net.gurigoro.kaiji.poker.PokerHand"
  end
  add_message "net.gurigoro.kaiji.poker.GetGameResultRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.poker.PlayerResult" do
    optional :userId, :int64, 1
    optional :gameResult, :enum, 2, "net.gurigoro.kaiji.poker.PlayerResult.GameResult"
    optional :gotPoints, :int64, 3
  end
  add_enum "net.gurigoro.kaiji.poker.PlayerResult.GameResult" do
    value :LOSE, 0
    value :TIE, 1
    value :WIN, 2
  end
  add_message "net.gurigoro.kaiji.poker.GetGameResultReply" do
    optional :isSucceed, :bool, 1
    repeated :playerResults, :message, 2, "net.gurigoro.kaiji.poker.PlayerResult"
  end
  add_message "net.gurigoro.kaiji.poker.DestroyGameRoomRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.poker.DestroyGameRoomReply" do
    optional :isSucceed, :bool, 1
  end
  add_enum "net.gurigoro.kaiji.poker.PlayerAction" do
    value :NONE, 0
    value :BET, 1
    value :CALL, 2
    value :RAISE, 3
    value :CHECK, 4
    value :FOLD, 5
    value :OPEN_CARDS, 6
  end
  add_enum "net.gurigoro.kaiji.poker.BettingResult" do
    value :SUCCEED, 0
    value :NO_ENOUGH_POINTS, 1
    value :NOT_ENOUGH_TO_RAISE, 2
    value :UNKNOWN_FAILED, 3
  end
  add_enum "net.gurigoro.kaiji.poker.PokerHand" do
    value :UNKNOWN, 0
    value :HIGH_CARDS, 1
    value :ONE_PAIR, 2
    value :TWO_PAIRS, 3
    value :THREE_OF_A_KIND, 4
    value :STRAIGHT, 5
    value :FLUSH, 6
    value :FULL_HOUSE, 7
    value :FOUR_OF_A_KIND, 8
    value :STRAIGHT_FLUSH, 9
    value :ROYAL_STRAIGHT_FLUSH, 10
  end
end

module Net
  module Gurigoro
    module Kaiji
      module Poker
        CreateNewGameRoomRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.CreateNewGameRoomRequest").msgclass
        CreateNewGameRoomReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.CreateNewGameRoomReply").msgclass
        BetRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.BetRequest").msgclass
        BetReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.BetReply").msgclass
        CallRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.CallRequest").msgclass
        CallReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.CallReply").msgclass
        RaiseRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.RaiseRequest").msgclass
        RaiseReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.RaiseReply").msgclass
        CheckRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.CheckRequest").msgclass
        CheckReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.CheckReply").msgclass
        FoldRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.FoldRequest").msgclass
        FoldReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.FoldReply").msgclass
        SetPlayersCardsRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.SetPlayersCardsRequest").msgclass
        SetPlayersCardsReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.SetPlayersCardsReply").msgclass
        GetGameResultRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.GetGameResultRequest").msgclass
        PlayerResult = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.PlayerResult").msgclass
        PlayerResult::GameResult = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.PlayerResult.GameResult").enummodule
        GetGameResultReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.GetGameResultReply").msgclass
        DestroyGameRoomRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.DestroyGameRoomRequest").msgclass
        DestroyGameRoomReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.DestroyGameRoomReply").msgclass
        PlayerAction = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.PlayerAction").enummodule
        BettingResult = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.BettingResult").enummodule
        PokerHand = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.poker.PokerHand").enummodule
      end
    end
  end
end
