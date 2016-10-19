require 'yaml'
require 'json'
require 'sinatra'
require 'sinatra/json'

require 'active_record'
dbconfig = YAML.load_file './config/database.yml'
ActiveRecord::Base.establish_connection dbconfig['db']['development']
ActiveRecord::Base.logger = Logger.new './log/database.log'

require_relative './model/user'

set :port, 80

get '/' do
  'test'
end

get '/user/:id' do
  user = User.find_by_id(params[id])
  json user.to_hash
end

post '/user/' do
  data = JSON.parse request.body.read
  if data['pointDifference'].positive?
    User.add_point(data['id'], data['pointDifference'])
  else
    User.reduce_point(data['id'], -data['pointDifference'])
  end
  user = User.find_by_id(params[id])
  json user.to_hash
end
