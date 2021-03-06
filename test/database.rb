require 'yaml'
require 'active_record'

dbconfig = YAML.load_file './config/database.yml'
ActiveRecord::Base.establish_connection dbconfig['db']['development']

require_relative './../model/user'
require_relative './../model/hand'
require_relative './../model/blackjack_player'
require_relative './../model/blackjack_room'
require_relative './../model/poker_room'
require_relative './../model/poker_player'
require_relative './../model/baccarat_room'
require_relative './../model/baccarat_player'
