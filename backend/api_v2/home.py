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
from backend.module.qsparser import QuerystringParser
from backend.module.qsparser import Filter
from backend.db.queries.behavior import *
from backend.recommendation.main import *
v2_home = Blueprint('/v2/home', __name__)



@v2_home.route('/', methods=['GET'])
@login_required
def get_clothes():
    try:
        args = request.args
        type = QuerystringParser.qs_parser(args.get('type').split(','))
        concept = QuerystringParser.qs_parser(args.get('concept').split(','))
        color = QuerystringParser.qs_parser(args.get('color').split(','))
        size = QuerystringParser.qs_bool(args.get('size'))
        price = QuerystringParser.int_list(QuerystringParser.empty_list(args.get('price').split(',')))
        price[1] = Filter.over_price(price[1])
        exception = QuerystringParser.empty_list(args.get('exception').split(','))
        result = filter_product(g.user_id, color, size, price, concept, type, exception)
        if not result:
            return 'response data is empty', 204
        else:
            result = get_product_list(result)
            return result, 200
    except Exception as Ex:
        print(Ex)
        return jsonify("Fail"), 500


@v2_home.route('/like', methods=['POST'])
@login_required
def like():
    try:
        body = request.get_json()
        product_id = body['product_id']
        if v2_insert_like(product_id) is True:
            return 'Success', 200
    except Exception as ex:
        if "duplicate" in str(ex):
            return jsonify("Duplicate"), 202
        else:
            return jsonify("Fail"), 500



@v2_home.route('/dislike', methods=['POST'])
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


@v2_home.route('/pass', methods=['POST'])
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


@v2_home.route('/purchase', methods=['POST'])
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