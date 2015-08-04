require 'rack'
app = Proc.new do |env|
  load './src/server.rb'
  Server.(env)
end

Rack::Handler::WEBrick.run app, Port: 4444
