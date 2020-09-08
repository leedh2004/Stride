# -*- coding: utf-8 -*-
import sys
from flask import Blueprint, jsonify, g
import json
from bson import ObjectId, json_util
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.db.queries.user import *
from backend.authentication.auth import *


login = Blueprint('login', __name__)


@login.route('/token')
def user_login():
    token = request.headers['Authorization']
    token = token.split(" ")[1]
    try:
        decoded_token = decode_jwt_token(token)
    except jwt.DecodeError:
        return jsonify("Decode Fail"), 403
    user_id = decoded_token['user_id']
    result = select_user(user_id)
    if result is None:
        insert_user(user_id)
    exp = decoded_token['exp']
    time = datetime.utcnow() - timedelta(days=3)
    exp = datetime.fromtimestamp(exp)
    compare = exp - time
    if int(compare.days) < 3:
        new_token = encode_jwt_token(user_id)
        g.user_id = user_id
        flag = select_user_profile_flag()
        size = select_user_size()
        return jsonify({"token": new_token, "user_id": user_id, "profile_flag": flag, "size": size}), 200
    elif int(compare.days) < 0:
        return jsonify("Fail"), 403
    else:
        new_token = encode_jwt_token(user_id)
        update_login_timestamp(user_id)
        g.user_id = user_id
        result = select_user_profile_flag()
        size = select_user_size()
        return jsonify({"token": new_token, "user_id": user_id, "profile_flag": result, "size": size}), 200
