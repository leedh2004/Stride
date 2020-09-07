# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify, g
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
    access_token = body['access_token']
    channel = body['channel']
    headers = {
        'Content-Type': "application/x-www-form-urlencoded",
        'Cache-Control': "no-cache"
    }
    if channel == 'kakao':
        url = "https://kapi.kakao.com/v2/user/me"
        headers.update({"Authorization": "Bearer " + str(access_token)})
        response = requests.request("POST", url, headers=headers)
        response_json = response.json()
        print('kakao : ', response_json)
        user_id = response_json.get('id')
        account = response_json.get('kakao_account')
        id = str(user_id) + "@kakao.com"
        insert_user(id)
        user_id = str(id)
        print('user_id', user_id)
        g.user_id = user_id
        if account['has_email'] is True:
            update_user_email(id, str(account['email']))
        flag = select_user_profile_flag()
        size = select_user_size()
        token = encode_jwt_token(id)
        return jsonify({"token": token, "user_id": user_id, "profile_flag": flag, "size": size}), 200
    elif channel == 'apple':
        user_id = access_token
        user_id = str(user_id).split('@')[0] + '@apple.com'
        insert_user(user_id)
        update_user_email(user_id, user_id)
        g.user_id = user_id
        flag = select_user_profile_flag()
        size = select_user_size()
        token = encode_jwt_token(user_id)
        return jsonify({"token": token, "user_id": user_id, "profile_flag": flag, "size": size}), 200
