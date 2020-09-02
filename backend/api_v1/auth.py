# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify
import requests
import json
from bson import ObjectId, json_util
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.authentication.auth import *

auth = Blueprint('auth', __name__)

@auth.route('/token', methods=['POST'])
def login():
    body = request.get_json()
    access_token = body['product_id']
    channel = body['channel']
    headers = {
        'Content-Type': "application/x-www-form-urlencoded",
        'Cache-Control': "no-cache"
    }
    print(body)
    if channel == 'kakao':
        url = "https://kapi.kakao.com/v2/user/me"
        headers.update({"Authorization": "Bearer " + str(access_token)})
        response = requests.request("POST", url, headers=headers)
        response_json = response.json()
        print('kakao : ', response_json)
        user_id = response_json.get('id')
        account = response_json.get('kakao_account')
        id = str(user_id) + "@kakao"
        insert_user(id)
        if account['has_email'] is True:
            update_user_email(id, str(account['email']))
        flag = select_user_profile_flag(id)
        size = select_user_size(id)
        token = encode_jwt_token(id)
        user_id = str(id) + "@" + "kakao"
        return jsonify({"token": token, "user_id": user_id, "profile_flag": flag, "size": size}), 200
