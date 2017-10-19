class PointRoutes < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    response.headers["Access-Control-Allow-Origin"] = "*"
    if request.request_method == 'OPTIONS'
      response.headers["Allow"] = "HEAD,GET,PUT,POST,DELETE,OPTIONS"
      response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept"

      halt 200
    end
  end

  post('/get_point_balance') do
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    user = User.find_by_id(params[:userId])
    if user.blank?
      json isSucceed: false
    else
      json isSucceed: true,
           userId: user.id,
           pointBalance: user.points
    end
  end

  post('/add_point') do
    params = {}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }])
    result = User.add_point(params[:userId], params[:addPoints].to_i)
    if !result
      json isSucceed: false
    else
      json isSucceed: true,
           userId: params[:userId],
           addedPoints: params[:addPoints],
           pointBalance: User.find_by_id(params[:userId]).points
    end
  end
end
