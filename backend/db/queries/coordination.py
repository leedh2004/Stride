from flask import g
import json
from bson import json_util
from backend.db.init import *
from backend.db.model.coordination import *
from backend.db.model.product import *
from backend.module.db import DBMapping


def insert_coordination(coor_name, top_product_id, bottom_product_id):
    with db_connect() as (service_conn, cursor):
        query = """INSERT INTO coordination(user_id, coor_name, product_top_id, product_bottom_id) VALUES (%s, %s, %s, %s)"""
        select_query = """SELECT coor_id FROM coordination WHERE user_id = %s AND product_top_id = %s AND product_bottom_id = %s"""
        try:
            cursor.execute(query, (g.user_id, coor_name, top_product_id, bottom_product_id))
            service_conn.commit()
            cursor.execute(select_query, (g.user_id, top_product_id, bottom_product_id))
            coor_id = cursor.fetchone()
            load = {'coor_id': coor_id[0]}
            return json.dumps(load, default=json_util.default, ensure_ascii=False)
        except:
            service_conn.rollback()
            raise


def update_coor_name(update_name, coor_id):
    with db_connect() as (service_conn, cursor):
        query = """UPDATE coordination SET coor_name = %s WHERE coor_id = %s"""
        try:
            cursor.execute(query, (update_name, coor_id))
            service_conn.commit()
        except:
            service_conn.rollback()
            raise


def get_coodination():
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM coordination WHERE user_id = %s ORDER BY created_at ASC"""
        product_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND product_id = %s"""
        try:
            cursor.execute(query, (g.user_id, ))
            coordination = cursor.fetchall()
            product = []
            colnames = DBMapping.mapping_column(cursor)
            for item in coordination:
                print(item)
                load = {}
                coor = CoordinationModel()
                coor.fetch_data(item, colnames)
                load.update(coor.__dict__)
                # Top
                cursor.execute(product_query, (coor.product_top_id, ))
                product_colname = DBMapping.mapping_column(cursor)
                product_top = cursor.fetchone()
                product_top_ins = ProductModel()
                product_top_ins.fetch_data(product_top, product_colname)
                print(product_top_ins.__dict__)
                for k in product_top_ins.__dict__:
                    new_key = "top_" + k
                    load[new_key] = product_top_ins.__dict__[k]
                # Bottom
                cursor.execute(product_query, (coor.product_bottom_id,))
                product_bottom = cursor.fetchone()
                product_bottom_ins = ProductModel()
                product_bottom_ins.fetch_data(product_bottom, product_colname)
                for k in product_bottom_ins.__dict__:
                    new_key = "bottom_" + k
                    load[new_key] = product_bottom_ins.__dict__[k]
                product.append(load)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except:
            pass


def delete_coordination(coor_id):
    with db_connect() as (service_conn, cursor):
        query = """DELETE FROM coordination WHERE coor_id = %s::int"""
        try:
            cursor.execute(query, (coor_id,))
            service_conn.commit()
        except:
            service_conn.rollback()
            raise