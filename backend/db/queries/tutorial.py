from backend.db.init import *
from backend.db.model.tutorial import *
from backend.module.concept import Concept
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


def extract_and_update_concept(product_id):
    with db_connect() as (service_conn, cursor):
        extract_query = """
        SELECT shop_concept, count(*)
        FROM (
          SELECT unnest(shop_concept) AS shop_concept
          FROM products p JOIN shop s ON p.shop_id = s.shop_id WHERE product_id IN %s) t
        GROUP BY shop_concept
        """
        update_query = """
        UPDATE users SET shop_concept = %s WHERE user_id = %s
        """
        try:
            cursor.execute(extract_query, (tuple(product_id),))
            result = cursor.fetchall()
            cal_result = Concept.calc_(result)
            cursor.execute(update_query, (cal_result, g.user_id))
            service_conn.commit()
            return True
        except Exception as Ex:
            print(Ex)
            raise

