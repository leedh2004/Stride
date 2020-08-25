# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify
import json
from bson import ObjectId, json_util
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.db.queries.coordination import *
from backend.authentication.auth import *

coordination = Blueprint('coordination', __name__)


@coordination.route('/', methods=['GET'])
@login_required
def get_coord():
    try:
        result = get_coodination()
    except:
        return jsonify("Fail"), 500
    return result, 200


@coordination.route('/', methods=['POST'])
@login_required
def create_coord():
    try:
        body = request.get_json()
        top_product_id = body['top_product_id']
        bottom_product_id = body['bottom_product_id']
        default_look_name = body['name']
        coor_id = insert_coordination(default_look_name, top_product_id, bottom_product_id)
    except:
        return jsonify("Fail"), 500
    return coor_id, 200


@coordination.route('/', methods=['DELETE'])
@login_required
def delete_coord():
    try:
        coor_id = request.args.get('coor_id')
        delete_coordination(coor_id)
    except:
        return jsonify("Fail"), 500
    return 'Success', 200


@coordination.route('/', methods=['PUT'])
@login_required
def modify_coor_name():
    try:
        body = request.get_json()
        coor_id = body['coor_id']
        update_name = body['update_name']
        update_coor_name(update_name, coor_id)
    except:
        return jsonify("Fail"), 500
    return 'Success', 200



