# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify
import json
from bson import ObjectId, json_util
import sys
sys.path.append('../')
sys.path.append('../../')
from backend.authentication.auth import *
from backend.db.queries.dressroom import *

v2_dressroom = Blueprint('v2/dressroom', __name__)



@v2_dressroom.route('/', methods=['GET'])
@login_required
def get_dress():
    try:
        result = get_dressroom()
    except:
        return jsonify("Fail"), 500
    return result, 200

@v2_dressroom.route('/folder', methods=['GET'])
@login_required
def get_dress_by_folder():
    args = request.args
    folder_id = int(args.get('folder_id'))
    order = int(args.get('order'))
    result = get_page_dressroom(folder_id, order)
    return result, 200

@v2_dressroom.route('/', methods=['PUT'])
@login_required
def delete_dress():
    try:
        body = request.get_json()
        product_id = body['product_id']
        delete_dressroom(product_id)
    except:
        return jsonify("Fail"), 500
    return jsonify("Success"), 200

@v2_dressroom.route('/', methods=['POST'])
@login_required
def create_dress():
    try:
        body = request.get_json()
        product_id = body['product_id']
        if insert_dress(product_id) is True:
            return jsonify("Success"), 200
    except Exception as Ex:
        print(Ex)
        return jsonify("Fail"), 500


@v2_dressroom.route('/folder', methods=['POST'])
@login_required
def create_folder():
    try:
        body = request.get_json()
        product_id = body['product_id']
        name = body['folder_name']
        result = create_dressroom_folder(product_id, name)
    except Exception as Ex:
        print(Ex)
        return jsonify("Fail"), 500
    return jsonify(result), 200


@v2_dressroom.route('/folder/name', methods=['PUT'])
@login_required
def modify_folder():
    try:
        body = request.get_json()
        folder_id = body['folder_id']
        update_name = body['update_name']
        modify_folder_name(update_name, folder_id)
    except Exception as Ex:
        print(Ex)
        return jsonify("Fail"), 500
    return jsonify("Success"), 201


@v2_dressroom.route('/folder/move', methods=['PUT'])
@login_required
def move_item():
    try:
        body = request.get_json()
        folder_id = body['folder_id']
        product_id = body['product_id']
        move_dressroom_folder(folder_id, product_id)
    except Exception as Ex:
        print(Ex)
        return jsonify("Fail"), 500
    return jsonify("Success"), 201


@v2_dressroom.route('/folder', methods=['DELETE'])
@login_required
def delete_folder():
    try:
        folder_id = request.args.get('folder_id')
        delete_dressroom_folder(folder_id)
    except Exception as Ex:
        print(Ex)
        return jsonify('Fail'), 500
    return jsonify('Success'), 200