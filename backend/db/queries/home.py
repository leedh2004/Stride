from backend.db.init import *
from backend.db.model.product import *
from flask import g
import json
from bson import json_util


def get_home_clothes():
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM Products ORDER BY random() LIMIT 10"""
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            product = []
            for item in result:
                load = ProductModel()
                load.fetch_data(item)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except:
            pass
        return 'None'


def get_clothes_category(type):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM Products WHERE type = %s ORDER BY random() LIMIT 10"""
        try:
            cursor.execute(query, (type,))
            result = cursor.fetchall()
            product = []
            for item in result:
                load = ProductModel()
                load.fetch_data(item)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except:
            pass
        return 'None'


def get_recommended_product(products):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM products WHERE product_id = %s"""
        try:
            product = []
            for product_id in products:
                cursor.execute(query, (product_id, ))
                result = cursor.fetchone()
                load = ProductModel()
                load.fetch_data(result)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except:
            pass
        return