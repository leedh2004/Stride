from flask import g
from backend.db.init import *


def delete_dressroom(product_id):
    cursor = service_conn.cursor()
    query = """DELETE FROM dressroom where user_id = %s::varchar and product_id = %s::int"""
    try:
        cursor.execute(query, (g.user_id, product_id))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def get_dressroom():
    cursor = service_conn.cursor()
    query = """SELECT * FROM dressroom WHERE user_id = %s"""
    try:
        cursor.execute(query, (g.user_id, ))
    except:
        pass
    cursor.close()