require 'redis'

session_id = 'session_1234567890'
user = ENV['SAUCE_USERNAME']
key = ENV['SAUCE_ACCESS_KEY']

session = { 
	:id => session_id,
	:user => user,
	:created => 'timestamp'
}

redis = Redis::Client.new()

redis.ping()

redis.set session_id, 'bar'

redis.hset session_id, session
redis.hmgetall(session_id)
redis.hkeys(session_id)