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


def update_login_timestamp():
    cursor = service_conn.cursor()
    query = """update users set last_login_at = CURRENT_TIMESTAMP where user_id = %s"""
    try:
        cursor.execute(query, (g.user_id, ))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    cursor.close()