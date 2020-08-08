from flask import Blueprint, request, render_template
import jwt
import sys
from datetime import datetime, timedelta
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
import requests, json
from bson import json_util
from config.oauthconfig import *
auth = Blueprint('auth', __name__)


@auth.route('/oauth', methods=['GET'])
def login():
    code = str(request.args.get('code'))
    print(request.args)
    url = "https://kauth.kakao.com/oauth/token"
    redirect_uri = str(SERVER) + "/auth/oauth"
    payload = "grant_type=authorization_code&client_id=" + str(KAKAO_KEY) + "&redirect_uri=" + str(redirect_uri) + "&code=" + str(code)
    headers = {
        'Content-Type': "application/x-www-form-urlencoded",
        'Cache-Control': "no-cache"
    }
    response = requests.request("POST", url, data=payload, headers=headers)
    token_json = response.json()
    print(token_json)
    access_token = token_json.get('access_token')
    print(access_token)
    headers.update({"Authorization": "Bearer " + str(access_token)})

    url = "https://kapi.kakao.com/v2/user/me"
    print(response.text)
    response = requests.request("POST", url, headers=headers)
    response_json = response.json()
    id = response_json.get('id')
    id = str(id) + "@kakao"
    token = encode_jwt_token(id)
    return render_template('oauth.html', token=token)


def encode_jwt_token(id):
    token = jwt.encode({'user_id': id, 'exp': datetime.utcnow() + timedelta(days=14)},
                       ENCRIPTION_SECRET, algorithm='HS256').decode('utf-8')
    return token


def decode_jwt_token(token):
    print(token)
    token = jwt.decode(token, ENCRIPTION_SECRET, algorithm='HS256')
    return token