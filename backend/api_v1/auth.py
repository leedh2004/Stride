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
from backend.module.db import DBEncryption

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
        print('response', response_json)
        user_id = response_json.get('id')
        profile = response_json.get('properties')
        id = str(user_id) + "@kakao.com"
        insert_user(id)
        print(profile)
        if profile['nickname'] is not None:
            name = profile['nickname']
            upsert_user_name(DBEncryption.encode_text(name), id)
        else:
            name = None
        user_id = str(id)
        g.user_id = user_id
        update_login_timestamp(user_id)
        flag = select_user_profile_flag()
        size = select_user_size()
        token = encode_jwt_token(id)
        likes = get_like_dislike_cnt()
        return jsonify({"token": token, "user_id": user_id, "profile_flag": flag,
                        "size": size, "likes": likes, "name": name}), 200
    elif channel == 'apple':
        user_id = access_token
        user_id = str(user_id).split('@')[0] + '@apple.com'
        name = body['name']
        if name is not None:
            name = json.dumps(name, default=json_util.default, ensure_ascii=False)
            upsert_user_name(DBEncryption.encode_text(name), user_id)
        name = select_user_name(user_id)
        insert_user(user_id)
        update_login_timestamp(user_id)
        g.user_id = user_id
        flag = select_user_profile_flag()
        size = select_user_size()
        token = encode_jwt_token(user_id)
        likes = get_like_dislike_cnt()
        return jsonify({"token": token, "user_id": user_id, "profile_flag": flag,
                        "size": size, "likes": likes, "name": name}), 200

