from flask import g
from backend.db.init import *


def insert_like(product_id):
    with db_connect() as (service_conn, cursor):
        query = """
        INSERT INTO evaluation(user_id, product_id, likes) VALUES (%s, %s, TRUE) 
        ON CONFLICT (user_id, product_id) DO UPDATE SET likes= TRUE
        """
        sequence_query = """INSERT INTO dressroom(user_id, product_id) VALUES (%s, %s)"""
        try:
            cursor.execute(query, (g.user_id, product_id, ))
            service_conn.commit()
            cursor.execute(sequence_query, (g.user_id, product_id))
            service_conn.commit()
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise


def insert_dislikes(product_id):
    with db_connect() as (service_conn, cursor):
        query = """
        INSERT INTO evaluation(user_id, product_id, likes) VALUES (%s, %s, FALSE ) 
        ON CONFLICT (user_id, product_id) DO UPDATE SET likes= FALSE 
        """
        try:
            cursor.execute(query, (g.user_id, product_id))
            service_conn.commit()
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise


def insert_pass(product_id):
    with db_connect() as (service_conn, cursor):
        query = """INSERT INTO pass(user_id, product_id) VALUES (%s, %s)"""
        try:
            cursor.execute(query, (g.user_id, product_id))
            service_conn.commit()
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise


def insert_purchases(product_id):
    with db_connect() as (service_conn, cursor):
        query = """INSERT INTO purchases(user_id, product_id) VALUES (%s, %s)"""
        try:
            cursor.execute(query, (g.user_id, product_id))
            service_conn.commit()
        except Exception as ex:
            print(ex)
            service_conn.rollback()
            raise
