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


@coordination.route('/mock/<user_id>', methods=['GET'])
@login_required
def get_mock_coordination(user_id):
    mock_response = [
        {
            'top_shop_name': 'sixsixgirls',
            'top_product_id': 101239,
            'top_thumbnail_url': "http://www.66girls.co.kr/web/product/big/20200309/1d03810cd4c121f31a5e65b774b4d117.jpg",
            'top_price': 19000,
            'top_product_name': "더블유반팔T",
            'top_product_url': "https://www.66girls.co.kr/product/detail.html?product_no=101239&cate_no=70&display_group=1",
            'top_type': "top",
            'top_size': {'free': {'shoulder': 51, 'hem': 50, 'arm_length': 15, 'bust': 56, 'length': 71}},
            'bottom_shop_name': 'noncode',
            'bottom_product_id': 101112,
            'bottom_thumbnail_url': "http://noncode.co.kr/web/product/medium/202007/ffae56a5932a52840d2a8de984be9e5b.jpg",
            'bottom_price': 19900,
            'bottom_product_name': "마블 밴드 와이드 팬츠",
            'bottom_product_url': "https://noncode.co.kr/product/detail.html?product_no=2031&cate_no=57&display_group=1",
            'bottom_type': "pants",
            'bottom_size': {'s': {'hem': 59, 'length': 44}, 'm': {'hem': 61, 'length': 46}}
        },
        {
            'top_shop_name': 'sixsixgirls',
            'top_product_id': 105361,
            'top_thumbnail_url': "http://www.66girls.co.kr/web/product/big/201910/3091a301c1bcb448b04f8ab76761865c.jpg",
            'top_price': 17000,
            'top_product_name': "오트골지니트",
            'top_product_url': "https://www.66girls.co.kr/product/detail.html?product_no=105361&cate_no=70&display_group=1",
            'top_type': "top",
            'top_size': {'free': {'shoulder': 55, 'hem': 59, 'arm_length': 21, 'bust': 56, 'length': 71}},
            'bottom_shop_name': 'sixsixgirls',
            'bottom_product_id': 102309,
            'bottom_thumbnail_url': "http://www.66girls.co.kr/web/product/big/20200408/6eb8eef88f742c781facc05e01ca6adf.jpg",
            'bottom_price': 19900,
            'bottom_product_name': "위키롱데님팬츠",
            'bottom_product_url': "https://www.66girls.co.kr/product/detail.html?product_no=102309&cate_no=71&display_group=1",
            'bottom_type': "pants",
            'bottom_size': {'s': {'hem': 19, 'length': 108}, 'm': {'hem': 21, 'length': 110},
                            'l': {'hem': 23, 'length': 112}}
        },
        {
            'top_shop_name': 'sixsixgirls',
            'top_product_id': 105089,
            'top_thumbnail_url': "http://www.66girls.co.kr/web/product/big/20200701/6cb1fae996da27f9a781f05bbc005364.jpg",
            'top_price': 17000,
            'top_product_name': "라피드반팔",
            'top_product_url': "https://www.66girls.co.kr/product/detail.html?product_no=105089&cate_no=70&display_group=1",
            'top_type': "top",
            'top_size': {'free': {'shoulder': 55, 'hem': 59, 'arm_length': 21, 'bust': 56, 'length': 71}},
            'bottom_shop_name': 'sixsixgirls',
            'bottom_product_id': 991992,
            'bottom_thumbnail_url': "http://www.66girls.co.kr/web/product/big/201904/6050368a72e07dfa372693e6d66d229f.jpg",
            'bottom_price': 19900,
            'bottom_product_name': "포켓코튼밴딩",
            'bottom_product_url': "https://www.66girls.co.kr/product/detail.html?product_no=91119&cate_no=71&display_group=1",
            'bottom_type': "pants",
            'bottom_size': {'s': {'hem': 19, 'length': 108}, 'm': {'hem': 21, 'length': 110},
                            'l': {'hem': 23, 'length': 112}}
        }
    ]
    return json.dumps(mock_response, default=json_util.default, ensure_ascii=False)


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
        insert_coordination(default_look_name, top_product_id, bottom_product_id)
    except:
        return jsonify("Fail"), 500
    return 'Success', 200


@coordination.route('/delete', methods=['POST'])
@login_required
def delete_coord():
    try:
        body = request.get_json()
        coor_id = body['coor_id']
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



