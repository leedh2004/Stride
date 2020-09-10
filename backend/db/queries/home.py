from backend.db.init import *
from backend.db.model.product import *
from backend.db.queries.user import *
from flask import g
import json
from bson import json_util

type_size_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id 
 AND (ARRAY [%s] <= waist or waist is NULL) 
 AND (ARRAY [%s] <= hip or hip is NULL) 
 AND (ARRAY [%s] <= thigh or thigh is NULL) 
 AND (ARRAY [%s] <= shoulder or shoulder is NULL) 
 AND (ARRAY [%s] <= bust or bust is NULL) AND type = %s AND p.active_flag = True ORDER BY random() LIMIT 10"""
all_size_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id 
 AND (ARRAY [%s] <= waist or waist is NULL) 
 AND (ARRAY [%s] <= hip or hip is NULL) 
 AND (ARRAY [%s] <= thigh or thigh is NULL) 
 AND (ARRAY [%s] <= shoulder or shoulder is NULL) 
 AND (ARRAY [%s] <= bust or bust is NULL) AND p.active_flag = True ORDER BY random() LIMIT 10"""

def get_all_type_clothes():
    with db_connect() as (service_conn, cursor):
        types = ['skirt', 'top', 'dress', 'pants', 'all']
        query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND type = %s AND p.active_flag = True ORDER BY random() LIMIT 10"""
        all_query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True ORDER BY random() LIMIT 10"""
        try:
            product = {
                'all': [],
                'skirt': [],
                'pants': [],
                'dress': [],
                'top': []
            }
            for type in types:
                if type is 'all':
                    cursor.execute(all_query)
                else:
                    cursor.execute(query, (type, ))
                result = cursor.fetchall()
                for item in result:
                    load = ProductModel()
                    load.fetch_data(item)
                    product[type].append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return 'None'


def get_all_type_clothes_sf():
    with db_connect() as (service_conn, cursor):
        types = ['skirt', 'top', 'dress', 'pants', 'all']
        tags = ['waist', 'hip', 'thigh', 'shoulder', 'bust']
        try:
            size = select_user_size()
            size = json.loads(size)
            size = dict(size)

            for tag in tags:
                if size[tag] is None:
                    size[tag] = 0.0
                else:
                    size[tag] = size[tag][0]
            product = {
                'all': [],
                'skirt': [],
                'pants': [],
                'dress': [],
                'top': []
            }
            for type in types:
                if type is 'all':
                    cursor.execute(all_size_query, (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust']))
                else:
                    cursor.execute(type_size_query, (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust'], type))
                result = cursor.fetchall()
                for item in result:
                    load = ProductModel()
                    load.fetch_data(item)
                    product[type].append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return 'None'


def get_type_clothes_sf(type):
    with db_connect() as (service_conn, cursor):
        tags = ['waist', 'hip', 'thigh', 'shoulder', 'bust']
        try:
            size = select_user_size()
            size = json.loads(size)
            size = dict(size)
            for tag in tags:
                if size[tag] is None:
                    size[tag] = 0.0
                else:
                    size[tag] = size[tag][0]
            if type == 'all':
                cursor.execute(all_size_query, (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust']))
            else:
                cursor.execute(type_size_query, (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust'], type))
            result = cursor.fetchall()
            product = []
            for item in result:
                load = ProductModel()
                load.fetch_data(item)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return 'None'


def get_clothes_category(type):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND type = %s AND p.active_flag = True ORDER BY random() LIMIT 10"""
        all_query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True ORDER BY random() LIMIT 10"""
        try:
            if type == 'all':
                cursor.execute(all_query)
            else:
                cursor.execute(query, (type,))
            result = cursor.fetchall()
            product = []
            for item in result:
                load = ProductModel()
                load.fetch_data(item)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return 'None'


def get_recommended_product(products):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True AND product_id IN %s"""
        try:
            product = []
            cursor.execute(query, (tuple(products), ))
            result = cursor.fetchall()
            for item in result:
                load = ProductModel()
                load.fetch_data(item)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass


# def get_recommended_product_all(products):
#     with db_connect() as (service_conn, cursor):
#         query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND product_id IN %s"""
#         try:
#             items = []
#             types = ['top', 'dress', 'pants', 'skirt']
#             product = {
#                 'all': [],
#                 'skirt': [],
#                 'pants': [],
#                 'dress': [],
#                 'top': []
#             }
#             cursor.execute(query, (tuple(products), ))
#             result = cursor.fetchall()
#             for item in result:
#                 load = ProductModel()
#                 load.fetch_data(item)
#                 product[load.__dict__['type']].append(load.__dict__)
#                 items.append(load.__dict__)
#             # for item['']
#             for type in types:
#                 product['all'] += (product[type][0:3])
#                 del product[type][0:3]
#             return json.dumps(product, default=json_util.default, ensure_ascii=False)
#         except Exception as ex:
#             print(ex)
#             pass

def get_recommended_product_all(products):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND product_id IN %s"""
        try:
            types = ['top', 'dress', 'pants', 'skirt', 'all']
            product = {
                'all': [],
                'skirt': [],
                'pants': [],
                'dress': [],
                'top': []
            }
            for type in types:
                cursor.execute(query, (tuple(products[type]), ))
                result = cursor.fetchall()
                for item in result:
                    load = ProductModel()
                    load.fetch_data(item)
                    product[type].append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as Ex:
            print(Ex)
            pass


def check_like_cnt():
    with db_connect() as (service_conn, cursor):
        query = """SELECT count(*) FROM likes WHERE user_id = %s"""
        update_query = """UPDATE users SET recommendation_flag = True WHERE user_id = %s"""
        try:
            cursor.execute(query, (g.user_id, ))
            cnt = cursor.fetchone()[0]
            if cnt >= 20:
                cursor.execute(update_query, (g.user_id, ))
                service_conn.commit()
        except Exception as ex:
            print(ex)
            pass