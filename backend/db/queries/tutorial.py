from backend.db.init import *
from backend.db.model.tutorial import *
from flask import g
import json
from bson import json_util

def get_random_list():
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM products ORDER BY random() limit 9"""
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            colnames = [desc[0] for desc in cursor.description]
            product = []
            for item in result:
                load = TutorialModel(colnames)
                load.fetch_data(item)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as Ex:
            print(Ex)
            raise

