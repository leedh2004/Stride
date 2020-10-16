import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.dev_app import *
from config.oauthconfig import *
import unittest
import requests
import json

class DressroomTest(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()
        self.headers = {'Content-Type': 'application/json', 'Authorization': TOKEN}

    def test_success_get_dressroom(self):
        rv = self.client.get('dressroom/', headers=self.headers)
        print(rv.get_data())
        self.assertEqual(rv.status_code, 200)

    def test_success_put_dressroom(self):
        body = {
            'product_id': 1
        }
        rv = self.client.put('dressroom/', headers=self.headers, data=json.dumps(body))
        print(rv.get_data())
        self.assertEqual(rv.status_code, 500)

    def test_success_create_folder(self):
        body = {
            'product_id': ['1'],
            'folder_name': 'unittest'
        }
        rv = self.client.post('dressroom/folder', headers=self.headers, data=json.dumps(body))
        print(rv.get_data())
        self.assertEqual(rv.status_code, 500)

    def test_success_move_folder(self):
        body = {
            'folder_id': 102,
            'product_id': ['1', '2', '3']
        }
        rv = self.client.put('dressroom/folder/move', headers=self.headers, data=json.dumps(body))
        print(rv.get_data())
        self.assertEqual(rv.status_code, 201)

    def test_success_modify_folder(self):
        body = {
            'folder_id': 102,
            'update_name': 'unittest2'
        }
        rv = self.client.put('dressroom/folder/name', headers=self.headers, data=json.dumps(body))
        print(rv.get_data())
        self.assertEqual(rv.status_code, 201)


if __name__ == '__main__':
    unittest.main()