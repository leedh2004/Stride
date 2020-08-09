from flask import Blueprint, request, render_template, g
from functools import wraps
import jwt
import sys
from datetime import datetime, timedelta
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
import requests, json
from bson import json_util
from config.oauthconfig import *
from backend.db.user import *
from backend.api_v1.auth import *
kakao = Blueprint('kakao', __name__)


@kakao.route('/oauth', methods=['GET'])
def login():
    code = str(request.args.get('code'))
    print(request.args)
    url = "https://kauth.kakao.com/oauth/token"
    redirect_uri = "http://15.165.33.138:5000/kakao/oauth"
    payload = "grant_type=authorization_code&client_id=" + str(KAKAO_KEY) + "&redirect_uri=" + str(redirect_uri) + "&code=" + str(code)
    headers = {
        'Content-Type': "application/x-www-form-urlencoded",
        'Cache-Control': "no-cache"
    }
    response = requests.request("POST", url, data=payload, headers=headers)
    token_json = response.json()
    access_token = token_json.get('access_token')
    headers.update({"Authorization": "Bearer " + str(access_token)})

    url = "https://kapi.kakao.com/v2/user/me"
    print(response.text)
    response = requests.request("POST", url, headers=headers)
    response_json = response.json()
    user_id = response_json.get('id')
    id = str(user_id) + "@kakao"
    insert_user(id)
    token = encode_jwt_token(id) + "," + str(user_id) + ","+"kakao"
    return render_template('oauth.html', token=token)

