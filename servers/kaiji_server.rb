require_relative './../protoc_ruby/kaiji_service_pb'

class KaijiServer < Net::Gurigoro::Kaiji::Kaiji::Service
  def ping
  end

  def log
  end

  def get_user_by_id
  end

  def add_user
  end

  def modify_user
  end
end
