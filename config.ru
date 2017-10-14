require 'rubygems' unless defined? ::Gem
require File.dirname( __FILE__ ) + '/main'

set :port, 8080
set :bind, "0.0.0.0"

map('/') do
  run HttpMain
end

map('/api/') do
  map('/blackjack/') do
    run BlackjackRoutes
  end
  map('/kaiji/') do
    run KaijiRoutes
  end
  map('/point/') do
    run PointRoutes
  end
  map('/poker/') do
    run PokerRoutes
  end
end

run Sinatra::Application
