require 'grpc'
require_relative './servers/blackjack_server'
require_relative './servers/kaiji_server'
require_relative './servers/point_server'

def main
  server = GRPC::RpcServer.new
  server.add_http2_port('0.0.0.0:11111')
  server.handle(BlackJackServer)
  server.handle(KaijiServer)
  server.handle(PointServer)
  server.run
end

main
