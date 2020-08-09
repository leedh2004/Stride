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
    result = get_home_clothes()
    return result, 200


@home.route('/result/like', methods=['POST'])
@login_required
def like():
    body = request.get_json()
    product_id = body['product_id']
    insert_like(product_id)
    return 200


@home.route('/result/dislike', methods=['POST'])
@login_required
def like():
    body = request.get_json()
    product_id = body['product_id']
    insert_dislikes(product_id)
    return 200


@home.route('/result/pass', methods=['POST'])
@login_required
def like():
    body = request.get_json()
    product_id = body['product_id']
    insert_pass(product_id)
    return 200

