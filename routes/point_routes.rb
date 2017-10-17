class PointRoutes < Sinatra::Base
  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end
  
  post('/get_point_balance') do
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
    result = User.add_point(params[:userId], params[:addPoints])
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
