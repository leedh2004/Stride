# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify, g
import json
import requests
from config.oauthconfig import *
from bson import ObjectId, json_util
import sys
import subprocess

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
        size = request.args.get('size')
        if select_user_recommenation_flag() is True:
            path = g.user_id + type
            if size == 'on':
                QUERY = ES_URL + '/recommendation_list_size_filtered/_doc/' + path
            elif size == 'off':
                QUERY = ES_URL + '/recommendation_list/_doc/' + path
            response = requests.get(QUERY)
            res = response.json()
            recommended_product = list(map(int, res['_source']['recommended_products']))
            result = get_recommended_product(recommended_product)
        else:
            check_like_cnt() ## 좋아요 몇 개 체크..
            if size == 'on':
                result = get_type_clothes_sf(type)
            elif size == 'off':
                result = get_clothes_category(type)
    except:
        return jsonify("Fail"), 500
    return result, 200


@home.route('/all', methods=['GET'])
@login_required
def get_all_type_clothes_limit_num():
    try:
        size = request.args.get('size')
        if select_user_recommenation_flag() is True:
            user_id = str(g.user_id)
            types = ['top', 'skirt', 'pants', 'dress']
            total_product = []
            for type in types:
                path = g.user_id + type
                if size == 'on':
                    QUERY = ES_URL + '/recommendation_list_size_filtered/_doc/' + path
                elif size == 'off':
                    QUERY = ES_URL + '/recommendation_list/_doc/' + path
                response = requests.get(QUERY)
                res = response.json()
                recommended_product = res['_source']['recommended_products']
                for item in recommended_product:
                    total_product.append(int(item))
            result = get_recommended_product_all(total_product)
        else:
            check_like_cnt()  ## 좋아요 몇 개 체크..
            if size == 'on':
                result = get_all_type_clothes_sf()
            elif size == 'off':
                result = get_all_type_clothes()
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
        return jsonify("Fail"), 500
    return 'Success', 200


