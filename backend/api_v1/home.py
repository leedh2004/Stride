# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify
import json
from bson import ObjectId, json_util
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.authentication.auth import *
from backend.db.queries.home import *
from backend.db.queries.behavior import *

home = Blueprint('home', __name__)


@home.route('/', methods=['GET'])
@login_required
def get_clothes():
    try:
        result = get_home_clothes()
    except:
        return jsonify("Fail"), 500
    return result, 200


@home.route('/like', methods=['POST'])
@login_required
def like():
    try:
        body = request.get_json()
        product_id = body['product_id']
        insert_like(product_id)
    except:
        return jsonify("Fail"), 500
    return 'Success', 200


@home.route('/dislike', methods=['POST'])
@login_required
def dislike():
    try:
        body = request.get_json()
        product_id = body['product_id']
        insert_dislikes(product_id)
    except:
        return jsonify("Fail"), 500
    return 'Success', 200


@home.route('/pass', methods=['POST'])
@login_required
def passes():
    try:
        body = request.get_json()
        product_id = body['product_id']
        insert_pass(product_id)
    except:
        return jsonify("Fail"), 500
    return 'Success', 200

