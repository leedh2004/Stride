import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.dev_app import *
from config.oauthconfig import *
from backend.db.init import *
import unittest
import requests
import json

class HomeTest(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()
        self.headers = {'Content-Type': 'application/json', 'Authorization': TOKEN}

    def test_success_home_pant_on(self):
        rv = self.client.get('home?type=pants&size=on', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_pant_off(self):
        rv = self.client.get('home?type=pants&size=off', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_top_on(self):
        rv = self.client.get('home?type=top&size=on', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_top_off(self):
        rv = self.client.get('home?type=top&size=off', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_skirt_on(self):
        rv = self.client.get('home?type=skirt&size=on', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_skirt_off(self):
        rv = self.client.get('home?type=skirt&size=off', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_dress_on(self):
        rv = self.client.get('home?type=dress&size=on', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_dress_on(self):
        rv = self.client.get('home?type=dress&size=off', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_all_on(self):
        rv = self.client.get('home?type=all&size=on', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_all_off(self):
        rv = self.client.get('home?type=all&size=off', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_sucess_home_all_cate_off(self):
        rv = self.client.get('home/all?size=off', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_sucess_home_all_cate_on(self):
        rv = self.client.get('home/all?size=on', headers=self.headers)
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_like(self):
        body = {
            "product_id": 1000
        }
        rv = self.client.post('home/like', headers=self.headers, data=json.dumps(body))
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 202)

    def test_success_home_dislike(self):
        body = {
            "product_id": 1000
        }
        rv = self.client.post('home/dislike', headers=self.headers, data=json.dumps(body))
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_home_pass(self):
        body = {
            "product_id": 1
        }
        rv = self.client.post('home/pass', headers=self.headers, data=json.dumps(body))
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 202)

    def test_success_home_purchase(self):
        body = {
            "product_id": 1
        }
        rv = self.client.post('home/purchase', headers=self.headers, data=json.dumps(body))
        print('rv data', rv.get_data())
        self.assertEqual(rv.status_code, 202)

if __name__ == '__main__':
    unittest.main()