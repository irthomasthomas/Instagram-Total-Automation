import redis
from rq import Queue

r = redis.Redis()

from app import views
from app import tasks
