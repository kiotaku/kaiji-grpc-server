# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: blackjack.proto

require 'google/protobuf'

require_relative './trump_pb'
Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "net.gurigoro.kaiji.blackjack.CreateNewGameRoomRequest" do
    optional :accessToken, :string, 1
    repeated :usersId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.blackjack.CreateNewGameRoomReply" do
    optional :isSucceed, :bool, 1
    optional :gameRoomId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.blackjack.BettingRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
    optional :betPoints, :int64, 4
  end
  add_message "net.gurigoro.kaiji.blackjack.BettingReply" do
    optional :result, :enum, 1, "net.gurigoro.kaiji.blackjack.BettingReply.BettingResult"
    optional :userId, :int64, 2
  end
  add_enum "net.gurigoro.kaiji.blackjack.BettingReply.BettingResult" do
    value :SUCCEED, 0
    value :NO_ENOUGH_POINTS, 1
    value :ALREADY_BETTED, 2
    value :UNKNOWN_FAILED, 3
  end
  add_message "net.gurigoro.kaiji.blackjack.FirstDealPlayerCards" do
    optional :userId, :int64, 1
    optional :cards, :message, 2, "net.gurigoro.kaiji.TrumpCards"
  end
  add_message "net.gurigoro.kaiji.blackjack.SetFirstDealedCardsRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    repeated :playerCards, :message, 3, "net.gurigoro.kaiji.blackjack.FirstDealPlayerCards"
  end
  add_message "net.gurigoro.kaiji.blackjack.AllowedPlayerActions" do
    optional :userId, :int64, 1
    optional :cardPoints, :int64, 2
    repeated :actions, :enum, 3, "net.gurigoro.kaiji.blackjack.PlayerAction"
  end
  add_message "net.gurigoro.kaiji.blackjack.SetFirstDealedCardsReply" do
    optional :isSucceed, :bool, 1
    repeated :actions, :message, 2, "net.gurigoro.kaiji.blackjack.AllowedPlayerActions"
  end
  add_message "net.gurigoro.kaiji.blackjack.SetFirstDealersCardRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :card, :message, 3, "net.gurigoro.kaiji.TrumpCard"
  end
  add_message "net.gurigoro.kaiji.blackjack.SetFirstDealersCardReply" do
    optional :isSucceed, :bool, 1
  end
  add_message "net.gurigoro.kaiji.blackjack.HitRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
    optional :card, :message, 4, "net.gurigoro.kaiji.TrumpCard"
    optional :handsIndex, :int64, 5
  end
  add_message "net.gurigoro.kaiji.blackjack.HitReply" do
    optional :isSucceed, :bool, 1
    optional :userId, :int64, 2
    optional :isBusted, :bool, 3
    optional :cardPoints, :int64, 4
    repeated :allowedActions, :enum, 5, "net.gurigoro.kaiji.blackjack.PlayerAction"
  end
  add_message "net.gurigoro.kaiji.blackjack.StandRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
    optional :handsIndex, :int64, 4
  end
  add_message "net.gurigoro.kaiji.blackjack.StandReply" do
    optional :isSucceed, :bool, 1
  end
  add_message "net.gurigoro.kaiji.blackjack.SplitRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
  end
  add_message "net.gurigoro.kaiji.blackjack.SplitReply" do
    optional :isSucceed, :bool, 1
  end
  add_message "net.gurigoro.kaiji.blackjack.DoubleDownRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :userId, :int64, 3
  end
  add_message "net.gurigoro.kaiji.blackjack.DoubleDownReply" do
    optional :isSucceed, :bool, 1
    optional :userId, :int64, 2
    optional :isBusted, :bool, 3
    optional :cardPoints, :int64, 4
  end
  add_message "net.gurigoro.kaiji.blackjack.SetNextDealersCardRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
    optional :card, :message, 3, "net.gurigoro.kaiji.TrumpCard"
  end
  add_message "net.gurigoro.kaiji.blackjack.SetNextDealersCardReply" do
    optional :isSucceed, :bool, 1
    optional :cardPoints, :int64, 2
    optional :shouldHit, :bool, 3
    optional :isBusted, :bool, 4
  end
  add_message "net.gurigoro.kaiji.blackjack.GetGameResultRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.blackjack.PlayerResult" do
    optional :userId, :int64, 1
    optional :gameResult, :enum, 2, "net.gurigoro.kaiji.blackjack.PlayerResult.GameResult"
    optional :gotPoints, :int64, 3
  end
  add_enum "net.gurigoro.kaiji.blackjack.PlayerResult.GameResult" do
    value :LOSE, 0
    value :TIE, 1
    value :WIN, 2
  end
  add_message "net.gurigoro.kaiji.blackjack.GetGameResultReply" do
    optional :isSucceed, :bool, 1
    repeated :playerResults, :message, 2, "net.gurigoro.kaiji.blackjack.PlayerResult"
  end
  add_message "net.gurigoro.kaiji.blackjack.DestroyGameRoomRequest" do
    optional :accessToken, :string, 1
    optional :gameRoomId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.blackjack.DestroyGameRoomReply" do
    optional :isSucceed, :bool, 1
  end
  add_enum "net.gurigoro.kaiji.blackjack.PlayerAction" do
    value :UNKNOWN, 0
    value :HIT, 1
    value :STAND, 2
    value :SPLIT, 3
    value :DOUBLEDOWN, 4
  end
end

module Net
  module Gurigoro
    module Kaiji
      module Blackjack
        CreateNewGameRoomRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.CreateNewGameRoomRequest").msgclass
        CreateNewGameRoomReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.CreateNewGameRoomReply").msgclass
        BettingRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.BettingRequest").msgclass
        BettingReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.BettingReply").msgclass
        BettingReply::BettingResult = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.BettingReply.BettingResult").enummodule
        FirstDealPlayerCards = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.FirstDealPlayerCards").msgclass
        SetFirstDealedCardsRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.SetFirstDealedCardsRequest").msgclass
        AllowedPlayerActions = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.AllowedPlayerActions").msgclass
        SetFirstDealedCardsReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.SetFirstDealedCardsReply").msgclass
        SetFirstDealersCardRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.SetFirstDealersCardRequest").msgclass
        SetFirstDealersCardReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.SetFirstDealersCardReply").msgclass
        HitRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.HitRequest").msgclass
        HitReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.HitReply").msgclass
        StandRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.StandRequest").msgclass
        StandReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.StandReply").msgclass
        SplitRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.SplitRequest").msgclass
        SplitReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.SplitReply").msgclass
        DoubleDownRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.DoubleDownRequest").msgclass
        DoubleDownReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.DoubleDownReply").msgclass
        SetNextDealersCardRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.SetNextDealersCardRequest").msgclass
        SetNextDealersCardReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.SetNextDealersCardReply").msgclass
        GetGameResultRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.GetGameResultRequest").msgclass
        PlayerResult = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.PlayerResult").msgclass
        PlayerResult::GameResult = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.PlayerResult.GameResult").enummodule
        GetGameResultReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.GetGameResultReply").msgclass
        DestroyGameRoomRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.DestroyGameRoomRequest").msgclass
        DestroyGameRoomReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.DestroyGameRoomReply").msgclass
        PlayerAction = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.blackjack.PlayerAction").enummodule
      end
    end
  end
end
