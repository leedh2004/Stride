import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.dev_app import *
from config.oauthconfig import *
import unittest
import requests
import json

class CoordinationTest(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()
        self.headers = {'Content-Type': 'application/json', 'Authorization': TOKEN}

    def test_success_get_coordination(self):
        rv = self.client.get('coordination/', headers=self.headers)
        print(rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_create_coordination(self):
        body = {
            'top_product_id': 1,
            'bottom_product_id': 1,
            'name': 'test'
        }
        rv = self.client.post('coordination/', headers=self.headers, data=json.dumps(body))
        print(rv.get_data())
        self.assertEqual(rv.status_code, 202)

    def test_success_modify_coordination(self):
        body = {
            'coor_id': 303,
            'update_name': 'test'
        }
        rv = self.client.put('coordination/', headers=self.headers, data=json.dumps(body))
        print(rv.get_data())
        self.assertEqual(rv.status_code, 200)


if __name__ == '__main__':
    unittest.main()