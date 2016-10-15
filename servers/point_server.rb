require_relative './../protoc_ruby/point_services_pb'

class PointServer < Net::Gurigoro::Kaiji::Point::Service
  def get_point_balance(req, _call)
    user = User.find(req.userId)
    if user.present?
      Net::Gurigoro::Kaiji::GetPointBalanceReply.new(isSucceed: false)
    end
    Net::Gurigoro::Kaiji::GetPointBalanceReply.new(
      isSucceed: true,
      userId: user.id,
      pointBalance: user.points
    )
  end

  def add_point(req, _call)
    result = User.add_point(req.userId, req.points)
    Net::Gurigoro::Kaiji::AddPointReply.new(isSucceed: false) if result
    Net::Gurigoro::Kaiji::AddPointReply.new(
      isSucceed: true,
      userId: req.userId,
      addedPoints: req.points,
      pointBalance: User.find(req.userId).points
    )
  end
end
