# -*- coding: utf-8 -*-
import sys
from flask import Blueprint, jsonify
import json
from bson import ObjectId, json_util

sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.authentication.auth import *


login = Blueprint('login', __name__)


@login.route('/token')
def user_login():
    token = request.headers['Authorization']
    token = token.split(" ")[1]
    print(token)
    try:
        decoded_token = decode_jwt_token(token)
    except jwt.DecodeError:
        return jsonify("Decode Fail"), 404
    user_id = decoded_token['user_id']
    exp = decoded_token['exp']
    time = datetime.utcnow() - timedelta(days=3)
    exp = datetime.fromtimestamp(exp)
    compare = exp - time
    if int(compare.days) < 3:
        new_token = encode_jwt_token(user_id)
        return jsonify({"token": new_token})
    elif int(compare.days) < 0:
        return jsonify("Fail"), 403
    else:
        new_token = encode_jwt_token(user_id)
        return jsonify({"new_token": new_token}), 200
