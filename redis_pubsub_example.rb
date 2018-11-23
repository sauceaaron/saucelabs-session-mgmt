require 'redis'
require 'json'
require 'selenium/webdriver'

redis = Redis.new

data = {"user" => ARGV[1]}

redis.subscribe('rubyonrails', 'ruby-lang') do |on|
	on.message do |channel, msg|
		data = JSON.parse(msg)
		puts "##{channel} - [#{data['user']}]: #{data['msg']}"
	end
end

