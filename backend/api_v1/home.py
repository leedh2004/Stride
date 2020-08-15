# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify, g
import json
import requests
from config.oauthconfig import *
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
        type = request.args.get('type')
        types = ['top', 'dress', 'pants', 'skirt']
        if type is None:
            result = get_home_clothes()
        else:
            if type not in types:
                raise
            result = get_clothes_category(type)
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


@home.route('/purchase', methods=['POST'])
@login_required
def purchase():
    try:
        body = request.get_json()
        product_id = body['product_id']
        insert_purchases(product_id)
    except:
        return


@home.route('/recommendation', methods=['GET'])
@login_required
def get_recommendation():
    try:
        url = ES_URL
        response = requests.get(url + '/recommended_list/_search/?q=user_id:1450140593@kakao')
        res = response.json()
        recommended_list = res['hits']['hits'][0]['_source']['recommended_products']
        result = get_recommended_product(recommended_list)
    except:
        return jsonify('Fail'), 500
    return result, 200

