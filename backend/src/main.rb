require_relative 'parser'
input = ARGF.argv[0]
dbg  = ARGF.argv[1] || false
puts Parser.new(input, dbg).call()

