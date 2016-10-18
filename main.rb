require 'yaml'
require 'grpc'
require 'active_record'
require 'logger'
@logger = Logger.new './log/grpc.log'

dbconfig = YAML.load_file './config/database.yml'
ActiveRecord::Base.establish_connection dbconfig['db']['development']
ActiveRecord::Base.logger = Logger.new './log/database.log'

require_relative './model/user'
require_relative './model/hand'
require_relative './model/blackjack_room'
require_relative './model/blackjack_player'
require_relative './model/poker_room'
require_relative './model/poker_player'
require_relative './model/baccarat_room'
require_relative './model/baccarat_player'

require_relative './util/point_calculator'
require_relative './util/action_checker'

require_relative './servers/blackjack_server'
require_relative './servers/kaiji_server'
require_relative './servers/point_server'
require_relative './servers/poker_server'
require_relative './servers/baccarat_server'

def main
  server = GRPC::RpcServer.new
  server.add_http2_port('0.0.0.0:1257', :this_port_is_insecure)
  server.handle(BlackjackServer)
  server.handle(KaijiServer.new(@logger))
  server.handle(PointServer)
  server.handle(PokerServer)
  server.handle(BaccaratServer)
  server.run
end

main
