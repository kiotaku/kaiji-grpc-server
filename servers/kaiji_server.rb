require_relative './../protoc_ruby/kaiji_services_pb'

class KaijiServer < Net::Gurigoro::Kaiji::Kaiji::Service
  def initialize(logger)
    @logger = logger
  end

  def ping(_req, _call)
    Net::Gurigoro::Kaiji::PingReply.new(message: 'pong')
  end

  def log(req, _call)
    case req.LogLevel
    when Net::Gurigoro::Kaiji::LogLevel.LOG_DEBUG
      @logger.debug "user_id: #{req.userId} message: #{req.message}"
    when Net::Gurigoro::Kaiji::LogLevel.LOG_INFO
      @logger.info "user_id: #{req.userId} message: #{req.message}"
    when Net::Gurigoro::Kaiji::LogLevel.LOG_WARN
      @logger.warn "user_id: #{req.userId} message: #{req.message}"
    when Net::Gurigoro::Kaiji::LogLevel.LOG_ERROR
      @logger.error "user_id: #{req.userId} message: #{req.message}"
    when Net::Gurigoro::Kaiji::LogLevel.LOG_FATAL
      @logger.fatal "user_id: #{req.userId} message: #{req.message}"
    else
      @logger.unknown "user_id: #{req.userId} message: #{req.message}"
    end
    Net::Gurigoro::Kaiji::Empty.new
  end

  def get_user_by_id(req, _call)
    user_model_convert_to_get_user_reply(User.find_by_id(req.userId))
  end

  def add_user(req, _call)
    result = User.add(req.userId,
                      name: req.name,
                      is_available: req.isAvailable,
                      is_anonymous: req.isAnonymous)
    Net::Gurigoro::Kaiji::AddUserReply.new(isSucceed: result,
                                           userId: req.userId)
  end

  def modify_user(req, _call)
    result = User.modify(req.userId,
                         name: req.name,
                         is_available: req.isAvailable,
                         is_anonymous: req.isAnonymous)
    Net::Gurigoro::Kaiji::ModifyUserReply.new(isSucceed: result,
                                              userId: req.userId)
  end

  private

  def user_model_convert_to_get_user_reply(user)
    if user.blank?
      Net::Gurigoro::Kaiji::GetUserReply.new(
        isFound: false,
        userId: 0, name: '', point: 0,
        isAvailable: false, isAnonymous: false, continueCount: 0
      )
    else
      Net::Gurigoro::Kaiji::GetUserReply.new(
        isFound: true,
        userId: user.id, name: user.name, point: user.points,
        isAvailable: user.is_available, isAnonymous: user.is_anonymous,
        continueCount: user.continue_count
      )
    end
  end
end
