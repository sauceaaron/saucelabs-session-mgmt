# redis_test.py

import os
import redis

REDIS_HOST = os.environ['REDISLABS_HOST']
REDIS_PORT = os.environ['REDISLABS_PORT']
REDIS_PASS = os.environ['REDISLABS_PASSWORD']

r = redis.StrictRedis(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PASS)

concurrency = r.get('concurrency')

print("concurrency: ", concurrency.decode("utf-8"))
