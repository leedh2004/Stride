import sys
from flask import Blueprint, jsonify, render_template
import requests
import json
from bson import ObjectId, json_util
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.authentication.auth import *
kakao = Blueprint('kakao', __name__)


@kakao.route('/oauth', methods=['GET'])
def login():
    code = str(request.args.get('code'))
    print(request.args)
    url = "https://kauth.kakao.com/oauth/token"
    redirect_uri = "https://api-stride.com/kakao/oauth"
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
    print('kakao : ', response_json)
    user_id = response_json.get('id')
    account = response_json.get('kakao_account')
    id = str(user_id) + "@kakao"
    insert_user(id)
    if account['has_email'] is True:
        update_user_email(id, str(account['email']))

    token = encode_jwt_token(id) + "," + str(user_id) + ","+"kakao"
    return render_template('oauth.html', token=token)

