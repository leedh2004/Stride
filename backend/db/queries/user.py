from backend.db.init import *
from flask import g
import json
from bson import json_util
from backend.db.model.user import *

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
        query = """UPDATE users SET waist = %s , hip = %s, thigh = %s, shoulder = %s, bust = %s WHERE user_id = %s"""
        ts_query = """UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE user_id = %s"""
        try:
            load = (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust'], g.user_id)
            cursor.execute(query, load)
            service_conn.commit()
            cursor.execute(ts_query, (g.user_id, ))
            service_conn.commit()
            update_user_profile_view(g.user_id)
        except Exception as Ex:
            print(Ex)
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


def update_user_profile_view(user_id):
    with db_connect() as (service_conn, cursor):
        query = """UPDATE users SET profile_flag = True WHERE user_id = %s"""
        try:
            cursor.execute(query, (user_id,))
            service_conn.commit()
        except:
            service_conn.rollback()
            raise


def select_user_profile_flag(user_id):
    with db_connect() as (service_conn, cursor):
        query = """SELECT profile_flag FROM users WHERE user_id = %s"""
        try:
            cursor.execute(query, (user_id,))
            flag = cursor.fetchall()
            flag = flag[0]
            if flag is True:
                return True
            else:
                return False
        except:
            service_conn.rollback()
            raise


def select_user_size(user_id):
    with db_connect() as (service_conn, cursor):
        query = """SELECT waist, hip, thigh, hem, shoulder, bust FROM users WHERE user_id = %s"""
        try:
            cursor.execute(query, (user_id, ))
            item = cursor.fetchone()
            load = UserSizeModel()
            load.fetch_data(item)
            return json.dumps(load.__dict__, default=json_util.default, ensure_ascii=False)
        except:
            service_conn.rollback()
            raise
