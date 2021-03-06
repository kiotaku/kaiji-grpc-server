class KaijiRoutes < Sinatra::Base
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

  get('/top_user') do
    json User.select(Arel.star).order(:continue_count, points: :desc).limit(10).map{ |u| user_model_convert_to_get_user_reply(u) }
  end

  get('/ping') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    json message: 'pong'
  end

  post('/log') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    logger = Logger.new './log/application.log'
    case params[:logLevel].to_sym
    when :LOG_DEBUG
      logger.debug "user_id: #{params[:userId]} message: #{params[:message]}"
    when :LOG_INFO
      logger.info "user_id: #{params[:userId]} message: #{params[:message]}"
    when :LOG_WARN
      logger.warn "user_id: #{params[:userId]} message: #{params[:message]}"
    when :LOG_ERROR
      logger.error "user_id: #{params[:userId]} message: #{params[:message]}"
    when :LOG_FATAL
      logger.fatal "user_id: #{params[:userId]} message: #{params[:message]}"
    else
      logger.unknown "user_id: #{params[:userId]} message: #{params[:message]}"
    end
    status 200
    body ""
  end

  post('/get_user_by_id') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    json user_model_convert_to_get_user_reply(User.find_by_id(params[:userId]))
  end

  post('/add_user') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    result = User.add(params[:userId],
                      params[:autoAssignId],
                      name: params[:name],
                      is_available: params[:isAvailable],
                      is_anonymous: params[:isAnonymous])
    json isSucceed: result[0], userId: params[:autoAssignId] ? result[1] : params[:userId]
  end

  post('/modify_user') do
    old_params = params
    params = ({}.merge(params || {}).merge(Hash[JSON.parse(request.body.read).map{ |k, v| [k.to_sym, v] }]) rescue old_params)
    result = User.modify(params[:userId],
                         name: params[:name],
                         is_available: params[:isAvailable],
                         is_anonymous: params[:isAnonymous])
    json isSucceed: result, userId: params[:userId]
  end

  private

  def user_model_convert_to_get_user_reply(user)
    if user.blank?
      {
        isFound: false,
        userId: 0, name: '', point: 0,
        isAvailable: false, isAnonymous: false, continueCount: 0
      }
    else
      {
        isFound: true,
        userId: user.id, name: user.name, point: user.points,
        isAvailable: user.is_available, isAnonymous: user.is_anonymous,
        continueCount: user.continue_count
      }
    end
  end
end
