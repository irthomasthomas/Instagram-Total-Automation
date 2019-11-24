import redis
from rq import Connection, Worker
import sys

r = redis.Redis(host='localhost', port=6379, db=0)
# redis_key = "tagqueue"
with Connection():
    qs = sys.argv[1:] or ["default"]
    w = Worker(qs)
    w.work()

# scrape hashtags to redis 1
# push to stream

# Clean text
# Model
# fetch img
# fetch comments
# Extract price
# Publish
