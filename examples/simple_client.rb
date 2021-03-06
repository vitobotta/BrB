require File.join(File.dirname(__FILE__), '../init.rb')

port = 5555
host = 'localhost'

# Connecting to the core server, retrieving its interface object : core
# We do not want to expose an object, so the first parameter is nil
core = BrB::Tunnel.create(nil, "brb://#{host}:#{port}", :verbose => true)

# Calling 10 times an non blocking method on the distant core server
10.times do
  core.simple_api_method # Do not wait for response
end

# Calling 10 times again long treatment time distant methods
10.times do
  core.simple_long_api_method # Do not wait for response
end

# Calling a blocking method with _block on the distant core server :
puts " >> Calling 1s call, and wait for response..."
r = core.simple_api_method_block
puts " > Api response : #{r}"

puts " >> Calling long call, and wait for response..."
r = core.simple_long_api_method_block
puts " > Api long response : #{r}"

## Calling method with a callback block for handling the return value
core.simple_api_method do |r|
  puts " > Get the callback response : #{r}"
end

puts " >> Callback method has been called continue .."
sleep 2

core.stop_service

# Our job is over, close event machine :
EM.stop