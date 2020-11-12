# -*- coding: utf-8 -*-
import sys
from flask import Blueprint, jsonify, g
import json
from bson import ObjectId, json_util
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.db.queries.tutorial import *
from backend.authentication.auth import *


tutorial = Blueprint('tutorial', __name__)

@tutorial.route('/', methods=['GET'])
@login_required
def get_tutorial_list():
    try:
        result = get_random_list()
        return result, 200
    except:
        return jsonify("Fail"), 500


@tutorial.route('/', methods=['POST'])
@login_required
def submit_tutorial_result():
    try:
        body = request.get_json()
        product_id = body['product_id']
        update_user_profile_view(g.user_id)
        if extract_and_update_concept(product_id) is True:
            return jsonify("Success"), 200
    except:
        return jsonify("Fail"), 500
