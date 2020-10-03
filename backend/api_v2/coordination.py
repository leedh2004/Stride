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
from backend.db.queries.coordination import *
from backend.authentication.auth import *
from backend.db.queries.home import *
from backend.module.qsparser import QuerystringParser
from backend.db.queries.behavior import *
from backend.recommendation.main import *
v2_coordination = Blueprint('/v2/coordination', __name__)





@v2_coordination.route('/', methods=['GET'])
@login_required
def get_coord():
    try:
        result = get_coodination_with_folder()
    except:
        return jsonify("Fail"), 500
    return result, 200


@v2_coordination.route('/', methods=['POST'])
@login_required
def create_coord():
    try:
        body = request.get_json()
        top_product_id = body['top_product_id']
        bottom_product_id = body['bottom_product_id']
        default_look_name = body['name']
        coor_id = insert_coordination(default_look_name, top_product_id, bottom_product_id)
    except Exception as ex:
        if "duplicate" in str(ex):
            return jsonify("Duplicate"), 202
        else:
            return jsonify("Fail"), 500
    return coor_id, 200


@v2_coordination.route('/', methods=['DELETE'])
@login_required
def delete_coord():
    try:
        coor_id = request.args.get('coor_id')
        delete_coordination(coor_id)
    except:
        return jsonify("Fail"), 500
    return 'Success', 200


@v2_coordination.route('/', methods=['PUT'])
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


@v2_coordination.route('/folder', methods=['POST'])
@login_required
def create_coor_folder():
    try:
        body = request.get_json()
        coor_id = body['coor_id']
        name = body['folder_name']
        result = create_coordination_folder(coor_id, name)
        return result, 200
    except:
        return jsonify("Fail"), 500



@v2_coordination.route('/folder/name', methods=['PUT'])
@login_required
def modify_coor_folder_name():
    try:
        body = request.get_json()
        folder_id = body['folder_id']
        update_name = body['update_name']
        if update_coor_folder_name(update_name, folder_id) is True:
            return 'Success', 200
    except:
        return jsonify("Fail"), 500


@v2_coordination.route('/folder/move', methods=['PUT'])
@login_required
def move_coor_item_folder():
    try:
        body = request.get_json()
        folder_id = body['folder_id']
        coor_id = body['coor_id']
        if move_coordination_folder(folder_id, coor_id) is True:
            return 'Success', 200
    except:
        return jsonify('Fail'), 500


@v2_coordination.route('/folder', methods=['DELETE'])
@login_required
def delete_coor_folder():
    try:
        folder_id = request.args.get('folder_id')
        if delete_coordination_folder(folder_id) is True:
            return 'Success', 200
    except:
        return jsonify('Fail'), 500


