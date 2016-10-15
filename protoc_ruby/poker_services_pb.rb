# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: poker.proto for package 'net.gurigoro.kaiji.poker'

require 'grpc'
require_relative './poker_pb'

module Net
  module Gurigoro
    module Kaiji
      module Poker
        module Poker
          class Service

            include GRPC::GenericService

            self.marshal_class_method = :encode
            self.unmarshal_class_method = :decode
            self.service_name = 'net.gurigoro.kaiji.poker.Poker'

            rpc :CreateNewGameRoom, CreateNewGameRoomRequest, CreateNewGameRoomReply
            rpc :Bet, BetRequest, BetReply
            rpc :Call, CallRequest, CallReply
            rpc :Raise, RaiseRequest, RaiseReply
            rpc :Check, CheckRequest, CheckReply
            rpc :Fold, FoldRequest, FoldReply
            rpc :SetPlayersCards, SetPlayersCardsRequest, SetPlayersCardsReply
            rpc :GetGameResult, GetGameResultRequest, GetGameResultReply
            rpc :DestroyGameRoom, DestroyGameRoomRequest, DestroyGameRoomReply
          end

          Stub = Service.rpc_stub_class
        end
      end
    end
  end
end
