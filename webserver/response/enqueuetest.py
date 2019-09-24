
from redis import Redis
from rq import Queue

q = Queue(connection=Redis())

from rqtest import count_words
result = q.enqueue(count_words, 'http://nvie.com')