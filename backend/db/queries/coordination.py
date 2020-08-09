from flask import g
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
    try:
        cursor.execute(query, (g.user_id, ))
        coordination = cursor.fetchall()
        print(coordination)
    except:
        pass
    cursor.close()