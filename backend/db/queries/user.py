from backend.db.init import *
from flask import g


def insert_user(user_id):
    cursor = service_conn.cursor()
    query = """INSERT INTO users(user_id) VALUES (%s)"""
    try:
        cursor.execute(query, (user_id, ))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def insert_user_birth(year):
    cursor = service_conn.cursor()
    query = """UPDATE users SET birth_year = (%s) WHERE user_id = %s"""
    try:
        year = str(year) + '0101'
        cursor.execute(query, (year, g.user_id))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def update_user_size(size):
    cursor = service_conn.cursor()
    try:
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def update_login_timestamp(user_id):
    cursor = service_conn.cursor()
    query = """update users set last_login_at = CURRENT_TIMESTAMP where user_id = %s"""
    try:
        cursor.execute(query, (user_id, ))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()


def select_user(user_id):
    cursor = service_conn.cursor()
    query = """SELECT * FROM users where user_id = %s"""
    try:
        cursor.execute(query, (user_id,))
        result = cursor.fetchall()
        return result
    except:
        pass
    cursor.close()


def update_user_size(size):
    cursor = service_conn.cursor()
    query = """UPDATE users SET length = %s , waist = %s , hip = %s, thigh = %s, rise = %s, hem = %s, shoulder = %s, bust = %s, arm_length = %s where id = %s"""
    try:
        load = (size['length'], size['waist'], size['hip'], size['thigh'], size['rise'], size['hem'], size['shoulder'], size['bust'], size['arm_length'], g.user_id)
        cursor.execute(query, load)
        service_conn.commit()
    except:
        service_conn.rollback()
        raise
        pass
    finally:
        cursor.close()
