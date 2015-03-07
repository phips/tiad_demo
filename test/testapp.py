from app import app
from nose.tools import eq_,assert_regexp_matches
import json

test_app = app.test_client()

def test_homepage():
    ret = test_app.get('/')
    eq_(ret.status_code, 200)
    #import pdb; pdb.set_trace()
    assert_regexp_matches(ret.data, "Hello,\sTIAD")
