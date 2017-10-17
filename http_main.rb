class HttpMain < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end
  
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
end
