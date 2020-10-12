from flask import g
import json
from bson import json_util
from backend.db.init import *
from backend.db.model.coordination import *
from backend.db.model.coordinationfolder import CoordinationfolderModel
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
            return True
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

def delete_arr_coor(coor_id):
    with db_connect() as (service_conn, cursor):
        query = """DELETE FROM coordination WHERE coor_id IN %s"""
        try:
            cursor.execute(query, (tuple(coor_id), ))
            service_conn.commit()
            return True
        except:
            service_conn.rollback()
            raise


def create_coordination_folder(coor_id, name):
    with db_connect() as (service_conn, cursor):
        query = """INSERT INTO coordinationfolder(user_id, folder_name) VALUES (%s, %s)"""
        select_query = """SELECT * FROM coordinationfolder WHERE user_id = %s AND folder_name = %s"""
        update_query = """UPDATE coordination SET folder_id = %s WHERE user_id = %s AND coor_id IN %s"""
        try:
            cursor.execute(query, (g.user_id, name))
            service_conn.commit()
            cursor.execute(select_query, (g.user_id, name))
            colnames = DBMapping.mapping_column(cursor)
            item = cursor.fetchone()
            if coor_id != -1:
                cursor.execute(update_query, (item[0], g.user_id, tuple(coor_id)))
                service_conn.commit()
            load = CoordinationfolderModel()
            load.fetch_data(item, colnames)
            return json.dumps(load.__dict__, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise



def update_coor_folder_name(new_name, folder_id):
    with db_connect() as (service_conn, cursor):
        modify_name_query = """UPDATE coordinationfolder SET folder_name = %s WHERE folder_id = %s"""
        try:
            cursor.execute(modify_name_query, (new_name, folder_id))
            service_conn.commit()
            return True
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise


def move_coordination_folder(folder_id, coor_id):
    with db_connect() as (service_conn, cursor):
        query = """UPDATE coordination SET folder_id = %s WHERE user_id = %s AND coor_id IN %s"""
        try:
            if folder_id == 0:
                cursor.execute(query, (None, g.user_id, tuple(coor_id)))
            else:
                cursor.execute(query, (folder_id, g.user_id, tuple(coor_id)))
            service_conn.commit()
            return True
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise


def delete_coordination_folder(folder_id):
    with db_connect() as (service_conn, cursor):
        delete_dress_query = """DELETE FROM coordination WHERE folder_id = %s::int"""
        delete_folder_query = """DELETE FROM coordinationfolder WHERE folder_id = %s::int"""
        try:
            cursor.execute(delete_dress_query, (folder_id,))
            service_conn.commit()
            cursor.execute(delete_folder_query, (folder_id,))
            service_conn.commit()
            return True
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise


def get_coodination_with_folder():
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM coordination WHERE user_id = %s AND folder_id is NULL ORDER BY created_at DESC OFFSET 0 LIMIT 18"""
        folder_query = """SELECT * FROM coordination WHERE user_id = %s AND folder_id = %s ORDER BY created_at DESC OFFSET 0 LIMIT 18"""
        product_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND product_id = %s"""
        get_folder_query = """SELECT folder_id, folder_name FROM coordinationfolder WHERE user_id = %s ORDER BY created_at DESC"""
        try:
            products = {}
            products['info'] = []
            cursor.execute(get_folder_query, (g.user_id, ))
            result = cursor.fetchall()
            result.insert(0, (0, 'default'))
            for item in result:
                folder_id = item[0]
                folder_name = item[1]
                info = {'folder_id': folder_id, 'folder_name': folder_name}
                products['info'].append(info)
                products[folder_name] = []
                if folder_name is 'default':
                    cursor.execute(query, (g.user_id,))
                else:
                    cursor.execute(folder_query, (g.user_id, folder_id))
                coordination = cursor.fetchall()
                product = []
                colnames = DBMapping.mapping_column(cursor)
                for item in coordination:
                    load = {}
                    coor = CoordinationModel()
                    coor.fetch_data(item, colnames)
                    load.update(coor.__dict__)
                    # Top
                    cursor.execute(product_query, (coor.product_top_id,))
                    product_colname = DBMapping.mapping_column(cursor)
                    product_top = cursor.fetchone()
                    product_top_ins = ProductModel()
                    product_top_ins.fetch_data(product_top, product_colname)
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
                    products[folder_name].append(load)
            return json.dumps(products, default=json_util.default, ensure_ascii=False)
        except:
            raise


def get_page_coordination(folder_id, order, idx):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM coordination WHERE user_id = %s AND folder_id is NULL ORDER BY created_at DESC OFFSET %s LIMIT 18"""
        folder_query = """SELECT * FROM coordination WHERE user_id = %s AND folder_id = %s ORDER BY created_at DESC OFFSET %s LIMIT 18"""
        product_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND product_id = %s"""
        page = order * 18 + idx
        try:
            if folder_id == 0:
                cursor.execute(query, (g.user_id, page))
            else:
                cursor.execute(folder_query, (g.user_id, folder_id, page))
            coordination = cursor.fetchall()
            product = []
            colnames = DBMapping.mapping_column(cursor)
            for item in coordination:
                load = {}
                coor = CoordinationModel()
                coor.fetch_data(item, colnames)
                load.update(coor.__dict__)
                # Top
                cursor.execute(product_query, (coor.product_top_id,))
                product_colname = DBMapping.mapping_column(cursor)
                product_top = cursor.fetchone()
                product_top_ins = ProductModel()
                product_top_ins.fetch_data(product_top, product_colname)
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
        except Exception as Ex:
            print(Ex)
            raise
