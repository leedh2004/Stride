from flask import g
from backend.db.init import *


def insert_like(product_id):
    cursor = service_conn.cursor()
    query = """INSERT INTO likes(user_id, product_id) VALUES (%s, %s)"""
    sequence_query = """INSERT INTO dressroom(user_id, product_id) VALUES (%s, %s)"""
    try:
        cursor.execute(query, (g.user_id, product_id))
        cursor.execute(sequence_query, (g.user_id, product_id))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def insert_dislikes(product_id):
    cursor = service_conn.cursor()
    query = """INSERT INTO dislikes(user_id, product_id) VALUES (%s, %s)"""
    try:
        cursor.execute(query, (g.user_id, product_id))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def insert_pass(product_id):
    cursor = service_conn.cursor()
    query = """INSERT INTO pass(user_id, product_id) VALUES (%s, %s)"""
    try:
        cursor.execute(query, (g.user_id, product_id))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def insert_purchases(product_id):
    cursor = service_conn.cursor()
    query = """INSERT INTO purchases(user_id, product_id) VALUES (%s, %s)"""
    try:
        cursor.execute(query, (g.user_id, product_id))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


