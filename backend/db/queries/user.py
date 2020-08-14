from backend.db.init import *
from flask import g


def insert_user(user_id):
    with db_connect() as (service_conn, cursor):
        query = """INSERT INTO users(user_id) VALUES (%s)"""
        try:
            cursor.execute(query, (user_id, ))
            service_conn.commit()
        except:
            service_conn.rollback()
            pass


def insert_user_birth(year):
    with db_connect() as (service_conn, cursor):
        query = """UPDATE users SET birth_year = %s WHERE user_id = %s"""
        try:
            year = str(year) + '0101'
            cursor.execute(query, (year, g.user_id))
            service_conn.commit()
        except:
            service_conn.rollback()
            pass


def update_login_timestamp(user_id):
    with db_connect() as (service_conn, cursor):
        query = """update users set last_login_at = CURRENT_TIMESTAMP where user_id = %s"""
        try:
            cursor.execute(query, (user_id, ))
            service_conn.commit()
        except:
            service_conn.rollback()
            pass


def select_user(user_id):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM users where user_id = %s"""
        try:
            cursor.execute(query, (user_id,))
            result = cursor.fetchall()
            return result
        except:
            pass


def update_user_size(size):
    with db_connect() as (service_conn, cursor):
        query = """UPDATE users SET length = %s , waist = %s , hip = %s, thigh = %s, rise = %s, hem = %s, shoulder = %s, bust = %s, arm_length = %s where id = %s"""
        ts_query = """UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE user_id = %s"""
        try:
            load = (size['length'], size['waist'], size['hip'], size['thigh'], size['rise'], size['hem'], size['shoulder'], size['bust'], size['arm_length'], g.user_id)
            cursor.execute(query, load)
            service_conn.commit()
            cursor.execute(ts_query, (g.user_id, ))
            service_conn.commit()
        except:
            service_conn.rollback()
            raise


def update_user_concept(user_id, concept):
    with db_connect() as (service_conn, cursor):
        query = """UPDATE users SET shop_concept = %s WHERE user_id = %s"""
        try:
            load = (concept, user_id)
            cursor.execute(query, load)
            service_conn.commit()
        except:
            service_conn.rollback()
            raise


def update_user_email(user_id, email):
    with db_connect() as (service_conn, cursor):
        query = """UPDATE users SET email = %s WHERE user_id = %s"""
        try:
            load = (email, user_id)
            cursor.execute(query, load)
            service_conn.commit()
        except:
            service_conn.rollback()
            raise
