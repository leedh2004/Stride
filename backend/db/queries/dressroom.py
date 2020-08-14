from flask import g
from backend.db.init import *
from bson import json_util
from backend.db.model.product import *
import json


def delete_dressroom(product_id):
    with db_connect() as (service_conn, cursor):
        query = """DELETE FROM dressroom where user_id = %s::varchar and product_id = %s::int"""
        try:
            for del_id in product_id:
                cursor.execute(query, (g.user_id, del_id))
                service_conn.commit()
        except:
            service_conn.rollback()
            raise


def get_dressroom():
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM products p, dressroom d WHERE p.product_id = d.product_id AND user_id = %s ORDER BY d.created_at ASC"""
        try:
            cursor.execute(query, (g.user_id, ))
            result = cursor.fetchall()
            product = []
            for item in result:
                load = ProductModel()
                load.fetch_data(item)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except:
            pass

