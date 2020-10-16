import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.dev_app import *
from config.oauthconfig import *
import unittest
import requests
import json

class UserTest(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()
        self.headers = {'Content-Type': 'application/json', 'Authorization': TOKEN}

    def test_success_post_size(self):
        body = {
            'size': {
                'waist': [24, 28],
                'hip': None,
                'thigh': None,
                'shoulder': None,
                'bust': None
            }
        }
        rv = self.client.post('user/size', headers=self.headers, data=json.dumps(body))
        print(rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_post_birth(self):
        body = {
            'birth': 1995
        }
        rv = self.client.post('user/birth', headers=self.headers, data=json.dumps(body))
        print(rv.get_data())
        self.assertEqual(rv.status_code, 200)

if __name__ == '__main__':
    unittest.main()