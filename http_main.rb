require 'yaml'
require 'json'
require 'sinatra'
require 'sinatra/json'

require 'active_record'
dbconfig = YAML.load_file './config/database.yml'
mode = 'development'
if ENV['kaiji_exec'] == 'production'
  mode = 'production'
end

ActiveRecord::Base.establish_connection dbconfig['db'][mode]
ActiveRecord::Base.logger = Logger.new './log/database.log'

require_relative './model/user'
require_relative './model/event_switch'

set :port, 8080
set :bind, "0.0.0.0"

get '/' do
  'test'
end

get '/user/:id' do
  user = User.find_by_id(params['id'].to_i)
  json user.attributes
end

post '/user/' do
  if params[:pointDifference].to_i.positive?
    User.add_point(params[:id].to_i, params[:pointDifference].to_i)
  else
    User.reduce_point(params[:id].to_i, -params[:pointDifference].to_i)
  end
  user = User.find_by_id(params[:id].to_i)
  json user.attributes
end

get '/event-list/' do
  EventSwitch.all.attributes
end

get '/event/:name/on' do
  EventSwitch.where(event_name: params['name']).update_all(is_valid: true)
end

get '/event/:name/off' do
  EventSwitch.where(event_name: params['name']).update_all(is_valid: false)
end
