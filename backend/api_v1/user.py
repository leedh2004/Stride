# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify
import json
from bson import ObjectId, json_util
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.db.queries.user import *
from backend.authentication.auth import *

user = Blueprint('user', __name__)


@user.route('/size', methods=['POST'])
@login_required
def insert_user_size():
    body = request.get_json()
    size = body['size']
    print('api in', size)
    try:
        update_user_size(size)
    except:
        return jsonify("Fail"), 500
    return jsonify('Success'), 200


@user.route('/birth', methods=['POST'])
@login_required
def insert_user_birth_year():
    body = request.get_json()
    year = body['birth']
    try:
        insert_user_birth(year)
    except:
        return jsonify('Fail'), 500
    return jsonify('Success'), 200

