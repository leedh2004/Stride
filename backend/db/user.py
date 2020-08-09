from backend.db.init import *


def insert_user(user_id):
    cursor = service_conn.cursor()
    query = """INSERT INTO users(user_id) VALUES (%s)"""
    try:
        cursor.execute(query, (user_id, ))
        service_conn.commit()
    except:
        service_conn.rollback()
        pass
    finally:
        cursor.close()

