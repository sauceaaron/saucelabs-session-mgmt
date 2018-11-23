#riak-webdriver-sessions.rb

require 'riak'
	require 'selenium/webdriver'


def get_riak_client()
	riak_config = {
		:host => "localhost",
		:protocol => "pbc", 
		:pb_port => 8087
	}

	riak = Riak::Client.new(riak_config)
end


def get_saucelabs_job(sauce_username, session_id)
	job_endpoint = "https://saucelabs.com/rest/v1/#{sauce_username}/jobs/#{session_id}"
	
	job_request_config = {
		:user => ENV['SAUCE_USERNAME'], 
		:password => ENV['SAUCE_ACCESS_KEY'],
		:headers => { :accept => :json, :content_type => :json },
		:method => :get,
		:url => job_endpoint
	}

	job_request = Rest::Request.new(job_request_config)
	job_response = job_request.execute()
	job_results = JSON.parse(job_response.to_str)	
end


def get_saucelabs_session()
	sauce_url = "https://ondemand.saucelabs.com/wd/hub"

	capabilities = {
		:username => ENV['SAUCE_USERNAME'],
		:accessKey => ENV['SAUCE_ACCESS_KEY'],
		:platform => "Windows 10",
		:browserName => "Chrome",
		:version => "latest",
		:name => "test using riak"
	}

	webdriver_config = { 
		:remote => true, 
		:url => sauce_url, 
		:desired_capabilities => capabilities
	}

	driver = Selenium::WebDriver.for(webdriver_config)
end


def execute_webdriver_steps(driver)
	driver.get('https://saucedemo.com')
	puts driver.title
end

riak = get_riak_client()
driver = get_webdriver_session()

session = { 
	:session_id => session, 
	:status => active, 
	:user => ENV['SAUCE_USERNAME']
}

session = { :id => driver.session_id, :user => sauce_username, :status => 'active' }
session[:capabilities] => driver.capabilities // need to parse this for values

job_result = get_saucelabs_job(sauce_username, session_id)

session.merge(job_result)

execute_webdriver_steps()
driver.quit()

sessions = riak.bucket('sessions')
sessions.new(session)


=begin

1. get active sessions
2. if full, create reserve session
3. poll active sessions until one acquired / wait for message notification
4. move reserve session from queue to active sessions
5. --> create webdriver session
6. add session id to active session
7. execute webdriver steps
8. close webdriver session
9. move session from active to complete
10. --> get API data on session
11. update session info with creation time, etc.
12. batch run cleanup for errors / abandoned sessions

=end
