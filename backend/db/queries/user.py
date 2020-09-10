from backend.db.init import *
from flask import g
import json
from bson import json_util
from backend.db.model.user import *
from math import *

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
            sizes = {
                'waist': [],
                'hip': [],
                'thigh': [],
                'shoulder': [],
                'bust' : []
            }
            tags = ['waist', 'hip', 'thigh', 'shoulder', 'bust']
            for tag in tags:
                if size[tag] is None:
                    sizes[tag] = None
                else:
                    for item in size[tag]:
                        if tag == 'hip' or tag == 'bust':
                            sizes[tag].append((float(item) / 2))
                        elif tag == 'waist':
                            sizes[tag].append(float(floor(float(item) * 1.27)))
                        else:
                            sizes[tag].append((float(item)))
            load = (sizes['waist'], sizes['hip'], sizes['thigh'], sizes['shoulder'], sizes['bust'], g.user_id)
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


def select_user_profile_flag():
    with db_connect() as (service_conn, cursor):
        query = """SELECT profile_flag FROM users WHERE user_id = %s"""
        try:
            cursor.execute(query, (g.user_id,))
            flag = cursor.fetchall()
            flag = flag[0]
            if flag[0] is True:
                return True
            else:
                return False
        except:
            service_conn.rollback()
            raise


def select_user_size():
    with db_connect() as (service_conn, cursor):
        query = """SELECT waist, hip, thigh, shoulder, bust FROM users WHERE user_id = %s"""
        try:
            cursor.execute(query, (g.user_id, ))
            item = cursor.fetchone()
            load = UserSizeModel()
            load.origin_fetch_data(item)

            return json.dumps(load.__dict__, default=json_util.default, ensure_ascii=False)
        except:
            service_conn.rollback()
            raise


def insert_survey(cmt):
    with db_connect() as (service_conn, cursor):
        query = """INSERT INTO survey(user_id, comment) VALUES(%s, %s)"""
        try:
            print(g.user_id, cmt)
            cursor.execute(query, (g.user_id, cmt))
            service_conn.commit()
        except Exception as Ex:
            print(Ex)
            service_conn.rollback()
            raise
        return True


def select_user_recommenation_flag():
    with db_connect() as (service_conn, cursor):
        query = """SELECT recommendation_flag FROM users WHERE user_id = %s"""
        try:
            cursor.execute(query, (g.user_id,))
            flag = cursor.fetchall()
            flag = flag[0]
            if flag[0] is True:
                return True
            else:
                return False
        except:
            service_conn.rollback()
            raise