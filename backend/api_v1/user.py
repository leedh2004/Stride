# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify
import json
from bson import ObjectId, json_util
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.db.queries.user import *
from backend.authentication.encrypt import *
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


@user.route('/survey', methods=["POST"])
@login_required
def survey():
    body = request.get_json()
    comment = body['comment']
    try:
        result = insert_survey(comment)
        if result is True:
            return jsonify('Success'), 200
    except:
        return jsonify("Fail"), 500


@user.route('/history/<page>', methods=['GET'])
@login_required
def get_history(page):
    try:
        result = get_history_list(page)
        return result, 200
    except:
        return jsonify("Fail"), 500
