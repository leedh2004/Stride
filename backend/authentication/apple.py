import sys
from flask import Blueprint, jsonify, render_template
import requests
import json
from bson import ObjectId, json_util
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.authentication.auth import *
apple = Blueprint('apple', __name__)


@apple.route('/oauth', methods=['GET'])
def login():
    code = str(request.args.get('code'))
    print(request)
    print(code)
    print(request.args)
    # url = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&client_id=" + str(NAVER_KEY) + "&client_secret=" + str(NAVER_SECRET_KEY) + "&code=" + code
    # headers = {
    #     'Content-Type': "application/x-www-form-urlencoded",
    #     'Cache-Control': "no-cache"
    # }
    # response = requests.request("GET", url, headers=headers)
    # token_json = response.json()
    # access_token = token_json.get('access_token')
    # headers.update({"Authorization": "Bearer " + str(access_token)})
    # url = "https://openapi.naver.com/v1/nid/me"
    # response = requests.request("GET", url, headers=headers)
    # response_json = response.json()
    # print(response_json)
    #
    # response = response_json.get('response')
    #
    # user_id = response['id']
    # id = str(user_id) + "@naver"
    # insert_user(id)
    # token = encode_jwt_token(id) + "," + str(user_id) + ","+"naver"
    # return render_template('oauth.html', token=token)

