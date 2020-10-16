from backend.db.init import *
from backend.db.model.product import *
from backend.module.concept import Concept
from backend.db.queries.user import *
from flask import g
import json
from bson import json_util





def get_recommended_multi_mock_list():
    with db_connect() as (service_conn, cursor):
        mock_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True ORDER BY random() LIMIT 20"""
        eval_query = """SELECT * FROM evaluation WHERE user_id = %s AND product_id IN %s"""
        get_list_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True AND p.product_id IN %s"""
        get_user_concept = """SELECT ARRAY(SELECT unnest(shop_concept) FROM users WHERE user_id = %s EXCEPT SELECT unnest(ARRAY['basic']))"""
        select_product_by_concept = """
        SELECT * FROM products p JOIN shop s ON p.shop_id = s.shop_id
        WHERE s.shop_id IN (SELECT shop_id FROM shop s WHERE %s = ANY(s.shop_concept)) AND p.product_id NOT IN (SELECT product_id FROM evaluation WHERE likes is FALSE AND user_id = %s)
        ORDER BY random() LIMIT 20;
        """
        select_new_arrived = """SELECT * FROM products WHERE product_id IN(SELECT product_id FROM products ORDER BY created_at desc limit 1000) ORDER BY random() LIMIT 20"""
        cursor.execute(get_user_concept, (g.user_id, ))
        concept = cursor.fetchone()[0]
        concept_1 = concept[0]
        concept_2 = concept[1]
        total_result = {
            'recommend': [],
            'new_arrive': [],
            'concept1': {
                'concept_name': Concept.concept_format(concept_1),
                'product': []
            },
            'concept2': {
                'concept_name': Concept.concept_format(concept_2),
                'product': []
            },
        }

        for type in total_result.keys():
            product_eval = {}
            product_id = []
            if type == 'recommend':
                cursor.execute(mock_query)
            elif type == 'new_arrive':
                cursor.execute(select_new_arrived)
            elif type == 'concept1':
                cursor.execute(select_product_by_concept, (concept_1, g.user_id))
            elif type == 'concept2':
                cursor.execute(select_product_by_concept, (concept_2, g.user_id))
            result = cursor.fetchall()
            # ES MOCK product_id
            colnames = DBMapping.mapping_column(cursor)
            for item in result:
                product_id.append(item[colnames.get('product_id')])
            cursor.execute(eval_query, (g.user_id, tuple(product_id)))
            # Check History
            colnames = DBMapping.mapping_column(cursor)
            result = cursor.fetchall()
            for item in result:
                load = EvaluationModel()
                load.fetch_brief_data(item, colnames)
                brief_data = load.get_brief_data()
                product_eval[brief_data['product_id']] = brief_data['likes']

            # Select And update
            cursor.execute(get_list_query, (tuple(product_id), ))
            colnames = DBMapping.mapping_column(cursor)
            result = cursor.fetchall()
            for item in result:
                load = ProductModel()
                load.fetch_data(item, colnames)
                load_product_id = load.__dict__['product_id']
                if product_eval.get(load_product_id) is not None:
                    load.__dict__['likes'] = product_eval.get(load_product_id)
                else:
                    load.__dict__['likes'] = None
                if 'concept' in type:
                    total_result[type]['product'].append(load.__dict__)
                else:
                    total_result[type].append(load.__dict__)

        return json.dumps(total_result, default=json_util.default, ensure_ascii=False)
