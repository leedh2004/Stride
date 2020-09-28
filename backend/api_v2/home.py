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
from backend.db.queries.behavior import *
from backend.recommendation.main import *
v2_home = Blueprint('/v2/home', __name__)

## Type : top bottom skirt dress outer all
## Concept : all basic daily simple chic street romantic unique sexy vintage
## Price : gt=716&lt=819 all
## color : ...
## size : on off
@v2_home.route('/', methods=['GET'])
@login_required
def get_clothes():
    try:
        args = request.args
        type = QuerystringParser.qs_parser(args.get('type').split(','))
        concept = QuerystringParser.qs_parser(args.get('concept').split(','))
        color = QuerystringParser.qs_parser(args.get('color').split(','))
        size = args.get('size')
        price = args.get('price').split(',')

        mock_result = get_mock_product_list()
        return mock_result, 200
    except:
        return jsonify("Fail"), 500

