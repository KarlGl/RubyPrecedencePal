require 'pry'
require 'json'
class Server
  def self.call(env)
    send(case env['PATH_INFO']
    when '/q'
      :respond_with_parser
    when '/'
      :respond_with_index
    else
      # /favicon.ico and all that other BS goes here.
      :other
    end, env)
  end

  private

  def self.respond_with_index(env)
      ['200', {'Content-Type' => 'text/html'}, [File.read('../frontend/index.html')]]
  end

  def self.respond_with_parser(env)
    args = URI.unescape(env['QUERY_STRING'])
    load './src/parser.rb'
    parser = Parser.new(args)
    output = parser.()
    ['200', {'Content-Type' => 'application/json'}, [{value: output, error: parser.errors}.to_json]]
  end

  def self.other(env)
    ['200', {'Content-Type' => 'text/html'}, ["Fuck you"]]
  end
end
