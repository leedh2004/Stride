# -*- coding: utf-8 -*-
from flask import g
from backend.db.init import *
from bson import json_util
from backend.db.model.product import *
from backend.db.model.dressfolder import *
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
        query = """SELECT * FROM products p, dressroom d WHERE p.product_id = d.product_id AND user_id = %s AND d.folder_id = %s ORDER BY d.created_at ASC"""
        get_folder_query = """SELECT folder_id, folder_name FROM dressfolder WHERE user_id = %s"""
        get_default_query = """SELECT * FROM products p, dressroom d WHERE p.product_id = d.product_id AND user_id = %s AND d.folder_id is NULL ORDER BY d.created_at ASC"""
        try:
            product = {}
            product['info'] = []
            cursor.execute(get_folder_query, (g.user_id, ))
            result = cursor.fetchall()
            result.append(('default', 'default'))
            for item in result:
                folder_id = item[0]
                folder_name = item[1]
                info = {'folder_id': folder_id, 'folder_name': folder_name}
                product['info'].append(info)
                product[folder_name] = []
                if folder_name is 'default':
                    cursor.execute(get_default_query, (g.user_id, ))
                else:
                    cursor.execute(query, (g.user_id, folder_id))
                product_result = cursor.fetchall()
                for item in product_result:
                    load = ProductModel()
                    load.fetch_data(item)
                    del load.__dict__['image_url']
                    product[folder_name].append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except:
            pass


def create_dressroom_folder(name):
    with db_connect() as (service_conn, cursor):
        query = """INSERT INTO dressfolder(user_id, folder_name) VALUES (%s, %s)"""
        select_query = """SELECT * FROM dressfolder WHERE user_id = %s AND folder_name = %s"""
        try:
            cursor.execute(query, (g.user_id, name))
            service_conn.commit()
            cursor.execute(select_query, (g.user_id, name))
            item = cursor.fetchone()
            load = DressfolderModel()
            load.fetch_data(item)
            return json.dumps(load.__dict__, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise
            pass


def move_dressroom_folder(folder_id, product_id):
    with db_connect() as (service_conn, cursor):
        query = """UPDATE dressroom SET folder_id = %s WHERE user_id = %s AND product_id IN %s"""
        try:
            if folder_id == 'default':
                cursor.execute(query, (None, g.user_id, product_id))
            else:
                cursor.execute(query, (folder_id, g.user_id, product_id))
            service_conn.commit()
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise


def delete_dressroom_folder(folder_id):
    with db_connect() as (service_conn, cursor):
        delete_dress_query = """DELETE FROM dressroom WHERE folder_id = %s"""
        delete_folder_query = """DELETE FROM dressfolder WHERE folder_id = %s"""
        try:
            cursor.execute(delete_dress_query, (folder_id, ))
            service_conn.commit()
            cursor.execute(delete_folder_query, (folder_id,))
            service_conn.commit()
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise
    return


def modify_folder_name(new_name, folder_id):
    with db_connect() as (service_conn, cursor):
        modify_name_query = """UPDATE dressfolder SET folder_name = %s WHERE folder_id = %s"""
        try:
            cursor.execute(modify_name_query, (new_name, folder_id))
            service_conn.commit()
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise
        return