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
auth = Blueprint('auth', __name__)


@auth.route('/oauth', methods=['GET'])
def login():
    code = str(request.args.get('code'))
    print(request.args)
    url = "https://kauth.kakao.com/oauth/token"
    redirect_uri = "http://15.165.33.138:5000/auth/oauth"
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
    id = response_json.get('id')
    id = str(id) + "@kakao"
    insert_user(id)
    token = encode_jwt_token(id)
    return render_template('oauth.html', token=token)


def encode_jwt_token(id):
    token = jwt.encode({'user_id': id, 'exp': datetime.utcnow() + timedelta(days=14)},
                       ENCRIPTION_SECRET, algorithm='HS256').decode('utf-8')
    return token


def decode_jwt_token(token):
    token = jwt.decode(token, ENCRIPTION_SECRET, algorithm='HS256')
    return token


def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        headers = request.headers.get("Authorization")
        access_token = headers.split(' ')[1]
        if access_token is not None:
            try:
                payload = decode_jwt_token(access_token)
            except jwt.InvalidTokenError:
                payload = None
            if payload is None:
                return '', 401
            user_id = payload["user_id"]
            exp = payload["exp"]
            time = datetime.utcnow()
            exp = datetime.fromtimestamp(exp)
            compare = exp - time
            if int(compare.days) < 0:
                return '', 401
            g.user_id = user_id
            # g.user = get_user_info(user_id) if user_id else None
        else:
            return '', 401
        return f(*args, **kwargs)
    return decorated_function