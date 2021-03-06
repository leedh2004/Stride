from backend.db.init import *
from backend.db.model.tutorial import *
from backend.module.concept import Concept
from backend.module.db import DBMapping
from flask import g
import json
from bson import json_util


def get_random_list():
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM products ORDER BY random() limit 9"""
        try:
            cursor.execute(query)
            result = cursor.fetchall()
            colnames = DBMapping.mapping_column(cursor)
            product = []
            for item in result:
                load = TutorialModel()
                load.fetch_data(item, colnames)
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



class Tutorial:

    @staticmethod
    def cal_concept():
        with db_connect() as (service_conn, cursor):
            aggregate_concept_query = """
            SELECT shop_concept, count(*)
             FROM (
                SELECT unnest(s.shop_concept) AS shop_concept FROM evaluation e JOIN products p on e.product_id = p.product_id JOIN shop s ON p.shop_id = s.shop_id  WHERE user_id=%s AND likes is True) t
            GROUP BY shop_concept
            """
            update_query = """
            UPDATE users SET shop_concept = %s WHERE user_id = %s
            """
            try:
                cursor.execute(aggregate_concept_query, (g.user_id, ))
                result = cursor.fetchall()
                cal_result = Concept.calc_(result)
                cursor.execute(update_query, (cal_result, g.user_id))
                service_conn.commit()
                return True
            except Exception as Ex:
                print(Ex)
                return False
                raise