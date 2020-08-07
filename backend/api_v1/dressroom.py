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
            'size': {'free': {'shoulder': 55, 'hem': 59, 'arm_length': 21, 'bust': 56, 'length': 71}}
        },
        {
            'shop_name': 'feelings',
            'product_id': "101239",
            'thumbnail_url': "http://feelings.co.kr/web/product/big/20200522/e84c076c4409de9bc2a320d244e4642a.gif",
            'price': 19000,
            'product_name': "린넨썸머데님",
            'product_url': "https://feelings.co.kr/product/%EB%A6%B0%EB%84%A8%EC%8D%B8%EB%A8%B8%EB%8D%B0%EB%8B%98-2color/1682/category/44/display/1/",
            'type': "top",
            'size': {'free': {'shoulder': 51, 'hem': 50, 'arm_length': 15, 'bust': 56, 'length': 71}}
        },
        {
            'shop_name': 'noncode',
            'product_id': "101112",
            'thumbnail_url': "http://noncode.co.kr/web/product/medium/202007/ffae56a5932a52840d2a8de984be9e5b.jpg",
            'price': 19900,
            'product_name': "마블 밴드 와이드 팬츠",
            'product_url': "https://noncode.co.kr/product/detail.html?product_no=2031&cate_no=57&display_group=1",
            'type': "pants",
            'size': {'s': {'hem': 59, 'length': 44}, 'm': {'hem': 61, 'length': 46}}
        },
        {
            'shop_name': 'sixsixgirls',
            'product_id': "103960",
            'thumbnail_url': "https://www.66girls.co.kr/web/product/big/202007/671f8a32830319a239467fe2e973977c.jpg",
            'price': 21000,
            'product_name': "로빈플리츠롱OPS",
            'product_url': "https://www.66girls.co.kr/product/detail.html?product_no=105792&cate_no=233&display_group=1",
            'type': "dress",
            'size': {'free': {'shoulder': 55, 'hem': 59, 'arm_length': 21, 'bust': 56, 'length': 110}}
        },
        {
            'shop_name': 'sixsixgirls',
            'product_id': "105361",
            'thumbnail_url': "http://www.66girls.co.kr/web/product/big/201910/3091a301c1bcb448b04f8ab76761865c.jpg",
            'price': 17000,
            'product_name': "오트골지니트",
            'product_url': "https://www.66girls.co.kr/product/%EC%98%A4%ED%8A%B8%EA%B3%A8%EC%A7%80%EB%8B%88%ED%8A%B8/96071/category/50/display/1/",
            'type': "top",
            'size': {'free': {'shoulder': 55, 'hem': 59, 'arm_length': 21, 'bust': 56, 'length': 71}}
        },
        {
            'shop_name': 'noncode',
            'product_id': "105363",
            'thumbnail_url': "http://noncode.co.kr/web/product/medium/20200504/5692ff4070f3a2cc6f5b9c32d80a3365.jpg",
            'price': 27000,
            'product_name': "스웨트 와이드 조거 팬츠",
            'product_url': "https://noncode.co.kr/product/detail.html?product_no=1649&cate_no=57&display_group=1",
            'type': "pants",
            'size': {'free': {'hem': 59, 'length': 71}}
        },
        {
            'shop_name': 'dailyjou',
            'product_id': "3031",
            'thumbnail_url': "http://dailyjou.com/web/product/big/20200316/8624363fcc3489ca00a93c54d341f900.jpg",
            'price': 12000,
            'product_name': "유즈 라운드 티셔츠 - 7 color",
            'product_url': "http://dailyjou.com/product/detail.html?product_no=3031&cate_no=26&display_group=1",
            'type': "top",
            'size': {}
        },
        {
            'shop_name': 'sneeze',
            'product_id': "2242",
            'thumbnail_url': "http://sneeze.kr/web/product/big/20200428/865d6552c32cd33acbd47cf241f83031.jpg",
            'price': 12000,
            'product_name': "Multilayered Mini Skirt",
            'product_url': "http://sneeze.kr/product/multilayered-mini-skirt2color/2242/category/27/display/1/",
            'type': "skirt",
            'size': {'free': {'length': 45, 'hip': 52}}
        },
        {
            'shop_name': 'zeroninewomen',
            'product_id': "2112992",
            'thumbnail_url': "http://cdn3-aka.makeshop.co.kr/shopimages/09women/0360080036142.jpg?1580954319",
            'price': 9100,
            'product_name': "펠즌 맨투맨 밑단 배색 롱 원피스",
            'product_url': "http://www.09women.com/shop/shopdetail.html?branduid=2110618&xcode=077&mcode=006&scode=&type=Y&sort=manual&cur_code=077&GfDT=aGx3UFo%3D",
            'type': "dress",
            'size': {'free': {'length': 45, 'hip': 52}}
        },
        {
            'shop_name': 'sixsixgirls',
            'product_id': "923423",
            'thumbnail_url': "http://www.66girls.co.kr/web/product/big/201903/88b1cd057909598bab399144600f4979.jpg",
            'price': 14000,
            'product_name': "퓨어쉬폰플리츠",
            'product_url': "https://www.66girls.co.kr/product/detail.html?product_no=89701&cate_no=86&display_group=1",
            'type': "skirt",
            'size': {'free': {'length': 45, 'hip': 52}}
        },
    ]
    return json.dumps(mock_response, default=json_util.default, ensure_ascii=False)


@dressroom.route('/', methods=['POST'])
def create_dress():
    return


@dressroom.route('/', methods=['DELETE'])
def delete_dress():
    return