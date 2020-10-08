import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.dev_app import *
from config.oauthconfig import *
import unittest
import requests
import json

class LoginTest(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()
        self.headers = {'Content-Type': 'application/json', 'Authorization': TOKEN}

    def test_success_login(self):
        rv = self.client.get('login/token', headers=self.headers)
        print(rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_fail_Signature_expired_login(self):
        headers = {'Content-Type': 'application/json', 'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTQ0NTM4MjY2MUBrYWthby5jb20iLCJleHAiOjE1OTk0NjY4MTB9.IhSKwFxT8GsYeDxTr4MLyc7cfn6QtDLtaVrkcDbVfw0"}
        rv = self.client.get('login/token', headers=headers)
        self.assertEqual(rv.status_code, 500)

    def test_fail_forbidden_login(self):
        headers = {'Content-Type': 'application/json',
                   'Authorization': "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiMTQ0NTM4MjY2MUBrYWthby5jb20iLCJleHAiOjE1OTk0NjY4MTB9.IhSKwFxT8GsYeDxTr4MLyc7cfn6QtDLtaVrk0"}
        rv = self.client.get('login/token', headers=headers)
        self.assertEqual(rv.status_code, 403)

if __name__ == '__main__':
    unittest.main()