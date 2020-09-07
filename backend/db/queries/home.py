from backend.db.init import *
from backend.db.model.product import *
from flask import g
import json
from bson import json_util


def get_home_clothes():
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id ORDER BY random() LIMIT 10"""
        try:
            cursor.execute(query)
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


def get_all_type_clothes():
    with db_connect() as (service_conn, cursor):
        types = ['skirt', 'top', 'dress', 'pants', 'all']
        query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND type = %s ORDER BY random() LIMIT 10"""
        all_query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id ORDER BY random() LIMIT 10"""
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


def get_clothes_category(type):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND type = %s ORDER BY random() LIMIT 10"""
        try:
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
        query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND product_id = %s"""
        try:
            product = []
            for product_id in products:
                cursor.execute(query, (product_id, ))
                result = cursor.fetchone()
                load = ProductModel()
                load.fetch_data(result)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return