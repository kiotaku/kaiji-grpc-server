require 'yaml'
require 'active_record'
require 'logger'
require 'json'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/base'

dbconfig = YAML.load_file './config/database.yml'
mode = 'development'
if ENV['kaiji_exec'] == 'production'
  mode = 'production'
end

ActiveRecord::Base.establish_connection dbconfig['db'][mode]
ActiveRecord::Base.logger = Logger.new './log/database.log'

require_relative './model/user'
require_relative './model/hand'
require_relative './model/blackjack_room'
require_relative './model/blackjack_player'
require_relative './model/poker_room'
require_relative './model/poker_player'
require_relative './model/event_switch'

require_relative './util/point_calculator'
require_relative './util/action_checker'

require_relative './routes/blackjack_routes'
require_relative './routes/kaiji_routes'
require_relative './routes/point_routes'
require_relative './routes/poker_routes'
require_relative './http_main'
