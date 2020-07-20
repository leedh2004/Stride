# -*- coding: utf-8 -*-
from flask import Blueprint, jsonify
import json
from bson import ObjectId, json_util

dressroom = Blueprint('dressroom', __name__)


@dressroom.route('/<user_id>', methods=['GET'])
def get_dressroom(user_id):
    # return dress product
    mock_response = [
        {
            'shop_name': 'sixsixgirls',
            'product_id': "105361",
            'thumbnail_url': "http://www.66girls.co.kr/web/product/big/202007/5a9e8bccd96339abf87e10692af292aa.jpg",
            'price': 21000,
            'product_name': "리코카라가디건",
            'product_url': "https://www.66girls.co.kr/product/detail.html?product_no=105361&cate_no=70&display_group=1",
            'type': "top",
            'size': {'free': {'shoulder':55, 'hem': 59, 'arm_length': 21, 'bust': 56, 'length': 71}}
        },
        {
            'shop_name': 'sixsixgirls',
            'product_id': "101239",
            'thumbnail_url': "http://www.66girls.co.kr/web/product/big/20200309/1d03810cd4c121f31a5e65b774b4d117.jpg",
            'price': 19000,
            'product_name': "더블유반팔T",
            'product_url': "https://www.66girls.co.kr/product/detail.html?product_no=101239&cate_no=70&display_group=1",
            'type': "top",
            'size': {'free': {'shoulder': 51, 'hem': 50, 'arm_length': 15, 'bust': 56, 'length': 71}}
        },
        {
            'shop_name': 'sixsixgirls',
            'product_id': "101112",
            'thumbnail_url': "https://www.66girls.co.kr/product/detail.html?product_no=101112&cate_no=86&display_group=1",
            'price': 19900,
            'product_name': "자가드꽃A스커트",
            'product_url': "https://www.66girls.co.kr/product/detail.html?product_no=105361&cate_no=70&display_group=1",
            'type': "skirt",
            'size': {'s': {'hem': 59, 'length': 44}, 'm': {'hem': 61, 'length': 46}}
        },
        {
            'shop_name': 'sixsixgirls',
            'product_id': "103960",
            'thumbnail_url': "http://www.66girls.co.kr/web/product/big/20200527/309510a8651b2218567df62a2b0718e7.jpg",
            'price': 21000,
            'product_name': "데이지스퀘어OPS",
            'product_url': "https://www.66girls.co.kr/product/detail.html?product_no=103960&cate_no=233&display_group=1",
            'type': "dress",
            'size': {'free': {'shoulder': 55, 'hem': 59, 'arm_length': 21, 'bust': 56, 'length': 110}}
        },
        {
            'shop_name': 'sixsixgirls',
            'product_id': "105361",
            'thumbnail_url': "http://www.66girls.co.kr/web/product/big/201910/3091a301c1bcb448b04f8ab76761865c.jpg",
            'price': 17000,
            'product_name': "오트골지니트",
            'product_url': "https://www.66girls.co.kr/product/detail.html?product_no=105361&cate_no=70&display_group=1",
            'type': "top",
            'size': {'free': {'shoulder': 55, 'hem': 59, 'arm_length': 21, 'bust': 56, 'length': 71}}
        }
    ]
    return json.dumps(mock_response, default=json_util.default, ensure_ascii=False)