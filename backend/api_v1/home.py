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
from backend.recommendation.main import *
home = Blueprint('home', __name__)


@home.route('/', methods=['GET'])
@login_required
def get_clothes():
    try:
        type = request.args.get('type')
        size = request.args.get('size')
        if select_user_recommenation_flag() is True:
            if size == 'on':
                recommendation_list = get_item_recommendation(g.user_id, type, True)
            elif size == 'off':
                recommendation_list = get_item_recommendation(g.user_id, type, False)
            print(recommendation_list)
            result = get_recommended_product(recommendation_list[type])
        else:
            check_like_cnt() ## 좋아요 몇 개 체크..
            if size == 'on':
                random_list = get_type_clothes_sf(type)
            elif size == 'off':
                random_list = get_clothes_category(type)
            result = random_list
    except:
        return jsonify("Fail"), 500
    return result, 200


@home.route('/all', methods=['GET'])
@login_required
def get_all_type_clothes_limit_num():
    try:
        size = request.args.get('size')
        if select_user_recommenation_flag() is True:
            types = ['top', 'skirt', 'pants', 'dress', 'all']
            all_list = {}
            for type in types:
                if size == 'on':
                    recommendation_list = get_item_recommendation(g.user_id, type, True)
                elif size == 'off':
                    recommendation_list = get_item_recommendation(g.user_id, type, False)
                all_list.update(recommendation_list)
            result = get_recommended_product_all(all_list)
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
    except Exception as ex:
        if "duplicate" in str(ex):
            return jsonify("Duplicate"), 202
        else:
            return jsonify("Fail"), 500
    return 'Success', 200


@home.route('/dislike', methods=['POST'])
@login_required
def dislike():
    try:
        body = request.get_json()
        product_id = body['product_id']
        insert_dislikes(product_id)
    except Exception as ex:
        if "duplicate" in str(ex):
            return jsonify("Duplicate"), 202
        else:
            return jsonify("Fail"), 500
    return 'Success', 200


@home.route('/pass', methods=['POST'])
@login_required
def passes():
    try:
        body = request.get_json()
        product_id = body['product_id']
        insert_pass(product_id)
    except Exception as ex:
        if "duplicate" in str(ex):
            return jsonify("Duplicate"), 202
        else:
            return jsonify("Fail"), 500
    return 'Success', 200


@home.route('/purchase', methods=['POST'])
@login_required
def purchase():
    try:
        body = request.get_json()
        product_id = body['product_id']
        insert_purchases(product_id)
    except Exception as ex:
        if "duplicate" in str(ex):
            return jsonify("Duplicate"), 202
        else:
            return jsonify("Fail"), 500
    return 'Success', 200


