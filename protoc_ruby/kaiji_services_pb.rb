# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: kaiji.proto for package 'net.gurigoro.kaiji'

require 'grpc'
require_relative './kaiji_pb'

module Net
  module Gurigoro
    module Kaiji
      module Kaiji
        class Service

          include GRPC::GenericService

          self.marshal_class_method = :encode
          self.unmarshal_class_method = :decode
          self.service_name = 'net.gurigoro.kaiji.Kaiji'

          # Ping
          rpc :Ping, PingRequest, PingReply
          # Logging
          rpc :Log, LogRequest, Empty
          # Users
          rpc :GetUserById, GetUserByIdRequest, GetUserReply
          rpc :AddUser, AddUserRequest, AddUserReply
          rpc :ModifyUser, ModifyUserRequest, AddUserReply
        end

        Stub = Service.rpc_stub_class
      end
    end
  end
end
