# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify
import json
from bson import ObjectId, json_util
import sys
sys.path.append('../')
sys.path.append('../../')
from backend.authentication.auth import *
from backend.db.queries.dressroom import *

dressroom = Blueprint('dressroom', __name__)



@dressroom.route('/', methods=['GET'])
@login_required
def get_dress():
    try:
        result = get_dressroom()
    except:
        return jsonify("Fail"), 500
    return result, 200


@dressroom.route('/', methods=['PUT'])
@login_required
def delete_dress():
    try:
        body = request.get_json()
        product_id = body['product_id']
        delete_dressroom(product_id)
    except:
        return jsonify("Fail"), 500
    return jsonify("Success"), 200


@dressroom.route('/folder', methods=['POST'])
def create_folder():
    try:
        body = request.get_json()
        product_id = body['product_id']
        name = body['folder_name']
        create_dressroom_folder(product_id, name)
    except Exception as Ex:
        print(Ex)
        return jsonify("Fail"), 500
    return jsonify("Success"), 200


@dressroom.route('/folder/name', methods=['PUT'])
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


@dressroom.route('/folder/move', methods=['PUT'])
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


@dressroom.route('/folder', methods=['DELETE'])
def delete_folder():
    try:
        folder_id = request.args.get('folder_id')
        delete_dressroom_folder(folder_id)
    except Exception as Ex:
        print(Ex)
        return jsonify('Fail'), 500
    return jsonify('Success'), 200