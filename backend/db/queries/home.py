from backend.db.init import *
from flask import g
import json
from bson import json_util


def get_home_clothes():
    cursor = service_conn.cursor()
    query = """SELECT * FROM Products ORDER BY random() LIMIT 20"""
    try:
        cursor.execute(query)
        result = cursor.fetchall()
        product = []
        for item in result:
            load = {}
            load['product_id'] = item[0]
            load['product_url'] = item[3]
            load['product_name'] = item[4]
            load['price'] = item[5]
            load['thumbnail_url'] = item[6]
            load['image_url'] = item[7]
            load['type'] = item[8]
            product.append(load)
        cursor.close()
        return json.dumps(product, default=json_util.default, ensure_ascii=False)
    except:
        pass
    return 'None'


def get_clothes_category(type):
    cursor = service_conn.cursor()
    query = """SELECT * FROM Products WHERE type = %s ORDER BY random() LIMIT 20"""
    try:
        cursor.execute(query, (type,))
        result = cursor.fetchall()
        product = []
        for item in result:
            load = {}
            load['product_id'] = item[0]
            load['product_url'] = item[3]
            load['product_name'] = item[4]
            load['price'] = item[5]
            load['thumbnail_url'] = item[6]
            load['image_url'] = item[7]
            load['type'] = item[8]
            product.append(load)
        cursor.close()
        return json.dumps(product, default=json_util.default, ensure_ascii=False)
    except:
        pass
    return 'None'





