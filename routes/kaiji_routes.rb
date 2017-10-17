class KaijiRoutes < Sinatra::Base
  get('/ping') do
    json message: 'pong'
  end

  post('/log') do
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
    json user_model_convert_to_get_user_reply(User.find_by_id(params[:userId]))
  end

  post('/add_user') do
    result = User.add(params[:userId],
                      params[:autoAssignId],
                      name: params[:name],
                      is_available: params[:isAvailable],
                      is_anonymous: params[:isAnonymous])
    json isSucceed: result, userId: params[:userId]
  end

  post('/modify_user') do
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
