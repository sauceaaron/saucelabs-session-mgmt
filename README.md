# saucelabs-session-mgmt
Manage Sauce Labs session concurrency and build detailed analytics

Exploring Redis and Riak for storing sauce labs sessions


1. Use Redis List for keeping track of webdriver sessions

# add a new session
LPUSH sessionList 12345

# list all sessions
LRANGE sessionList 0 -1

# remove first session in list 
RPOP sessionList

# move from reserve bucket to active sessions
RPOPLPUSH reserveSessionList activeSessionList

# see how many active sessions (to prevent exceeding concurrency)
LLEN activeSessionList

# blocking version
BRPOPLPUSH reserveSessionList activeSessinList

# remove completed session from active and move to complete
LREM activeSessionList 12345

2. Collect / aggregate  webdriver session info

# before session starts
session = { :status => 'requested', :desired_capabilities => desired_capabilities }

# session is active
session.merge { :id => driver.session_id, :user => sauce_username, :status => 'active' }

# add actual capabilities
session[:capabilities] = driver.capabilities 
#TODO: need to get data from this object by manual serialization (e.g. capabilities[:browserName])

# after job is complete, get REST API info
job_result = get_saucelabs_job(sauce_username, session_id)
session.merge job_result

3. Store session info in hash / rejson
	use session id as hash key and as reference in reserve / active / complete list


HMSET session_123 'id' 123 'user' 'aaron' 'browser' 'chrome' 'status' 'active' 'created' '123123123'
HGETALL session_123


4. use a set for session ids, not a list

reserved sessions don't have a real session id, but still need a unique identifier

5. Use publish / subscribe to wait for active session / complete session notifications

PUBLISH activeSessions "session started: { id: ID, user: USER, etc}"
PUBLISH activeSessions "session completed: { ... }"
PUBLISH availableSessions "5"

SUBSCRIBE activeSessions availableSessions


either poll for active sessions and BRPUSHLPOP 

6. Use search for analytics or post process into a queryable data store

streams, map/reduce ?


