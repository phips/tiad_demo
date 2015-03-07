from app import app
from nose.tools import eq_
from pyquery import PyQuery as pq

test_app = app.test_client()

def test_homepage():
    ret = test_app.get('/')
    eq_(ret.status_code, 200)
    doc = pq(ret.data)
    # import pdb; pdb.set_trace()
    eq_(doc.find('h1').text(), "Hello, TIAD!")
