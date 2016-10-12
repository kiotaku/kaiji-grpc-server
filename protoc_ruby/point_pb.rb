# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: point.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "net.gurigoro.kaiji.GetPointBalanceRequest" do
    optional :accessToken, :string, 1
    optional :userId, :int64, 2
  end
  add_message "net.gurigoro.kaiji.GetPointBalanceReply" do
    optional :isSucceed, :bool, 1
    optional :userId, :int64, 2
    optional :pointBalance, :int64, 3
  end
  add_message "net.gurigoro.kaiji.AddPointRequest" do
    optional :accessToken, :string, 1
    optional :userId, :int64, 2
    optional :points, :int64, 3
    optional :reason, :string, 4
  end
  add_message "net.gurigoro.kaiji.AddPointReply" do
    optional :isSucceed, :bool, 1
    optional :userId, :int64, 2
    optional :addedPoints, :int64, 3
    optional :pointBalance, :int64, 4
  end
end

module Net
  module Gurigoro
    module Kaiji
      GetPointBalanceRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.GetPointBalanceRequest").msgclass
      GetPointBalanceReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.GetPointBalanceReply").msgclass
      AddPointRequest = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.AddPointRequest").msgclass
      AddPointReply = Google::Protobuf::DescriptorPool.generated_pool.lookup("net.gurigoro.kaiji.AddPointReply").msgclass
    end
  end
end
