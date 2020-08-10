from flask import g
import json
from bson import json_util
from backend.db.init import *


def insert_coordination(coor_name, top_product_id, bottom_product_id):
    cursor = service_conn.cursor()
    query = """INSERT INTO coordination(user_id, coor_name, top_product_id, bottom_product_id) VALUES (%s, %s, %s, %s)"""
    try:
        cursor.execute(query, (g.user_id, coor_name, top_product_id, bottom_product_id))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def update_coor_name(coor_id):
    cursor = service_conn.cursor()
    query = """UPDATE coordination SET coor_name = %s WHERE coor_id = %s"""
    try:
        cursor.execute(query, (coor_id,))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def get_coodination():
    cursor = service_conn.cursor()
    query = """SELECT * FROM coordination WHERE user_id = %s:"""
    product_query = """SELECT * FROM products WHERE product_id = %s"""
    try:
        cursor.execute(query, (g.user_id, ))
        coordination = cursor.fetchall()
        product = []
        for item in coordination:
            load = {}
            load['coor_id'] = item[0]
            product_top_id = item[3]
            product_bottom_id = item[4]
            cursor.execute(product_query, (product_top_id, ))
            product_top = cursor.fetchone()
            load['top_product_id'] = product_top[0]
            load['top_product_url'] = product_top[3]
            load['top_product_name'] = product_top[4]
            load['top_price'] = product_top[5]
            load['top_thumbnail_url'] = product_top[6]
            load['top_type'] = product_top[8]
            cursor.execute(product_query, (product_bottom_id,))
            product_bottom = cursor.fetchone()
            load['bottom_product_id'] = product_bottom[0]
            load['bottom_product_url'] = product_bottom[3]
            load['bottom_product_name'] = product_bottom[4]
            load['bottom_price'] = product_bottom[5]
            load['bottom_thumbnail_url'] = product_bottom[6]
            load['bottom_type'] = product_bottom[8]
            product.append(load)
        cursor.close()
        return json.dumps(product, default=json_util.default, ensure_ascii=False)
    except:
        pass
    cursor.close()


def delete_coordination(coor_id):
    cursor = service_conn.cursor()
    query = """DELETE FROM coordination WHERE coor_id = %s"""
    try:
        for del_id in coor_id:
            cursor.execute(query, (del_id,))
            service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()
