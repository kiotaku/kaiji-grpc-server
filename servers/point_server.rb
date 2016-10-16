require_relative './../protoc_ruby/point_services_pb'

class PointServer < Net::Gurigoro::Kaiji::Point::Service
  def get_point_balance(req, _call)
    user = User.find_by_id(req.userId)
    if user.blank?
      Net::Gurigoro::Kaiji::GetPointBalanceReply.new(isSucceed: false)
    else
      Net::Gurigoro::Kaiji::GetPointBalanceReply.new(
        isSucceed: true,
        userId: user.id,
        pointBalance: user.points
      )
    end
  end

  def add_point(req, _call)
    result = User.add_point(req.userId, req.addPoints)
    if !result
      Net::Gurigoro::Kaiji::AddPointReply.new(isSucceed: false)
    else
      Net::Gurigoro::Kaiji::AddPointReply.new(
        isSucceed: true,
        userId: req.userId,
        addedPoints: req.addPoints,
        pointBalance: User.find_by_id(req.userId).points
      )
    end
  end
end
