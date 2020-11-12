from backend.db.init import *
from backend.db.model.product import *
from backend.db.queries.user import *
from flask import g
import json
from bson import json_util

type_size_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id 
 AND (ARRAY [%s] <= waist or waist is NULL) 
 AND (ARRAY [%s] <= hip or hip is NULL) 
 AND (ARRAY [%s] <= thigh or thigh is NULL) 
 AND (ARRAY [%s] <= shoulder or shoulder is NULL) 
 AND (ARRAY [%s] <= bust or bust is NULL) AND type = %s AND p.active_flag = True ORDER BY random() LIMIT 10"""
all_size_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id 
 AND (ARRAY [%s] <= waist or waist is NULL) 
 AND (ARRAY [%s] <= hip or hip is NULL) 
 AND (ARRAY [%s] <= thigh or thigh is NULL) 
 AND (ARRAY [%s] <= shoulder or shoulder is NULL) 
 AND (ARRAY [%s] <= bust or bust is NULL) AND p.active_flag = True ORDER BY random() LIMIT 10"""

def get_all_type_clothes():
    with db_connect() as (service_conn, cursor):
        types = ['skirt', 'top', 'dress', 'pants', 'all']
        query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND type = %s AND p.active_flag = True ORDER BY random() LIMIT 10"""
        all_query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True ORDER BY random() LIMIT 10"""
        try:
            product = {
                'all': [],
                'skirt': [],
                'pants': [],
                'dress': [],
                'top': []
            }
            for type in types:
                if type == 'all':
                    cursor.execute(all_query)
                else:
                    cursor.execute(query, (type, ))
                result = cursor.fetchall()
                colnames = DBMapping.mapping_column(cursor)
                for item in result:
                    load = ProductModel()
                    load.fetch_data(item, colnames)
                    product[type].append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return 'None'


def get_all_type_clothes_sf():
    with db_connect() as (service_conn, cursor):
        types = ['skirt', 'top', 'dress', 'pants', 'all']
        tags = ['waist', 'hip', 'thigh', 'shoulder', 'bust']
        try:
            size = select_user_size()
            size = json.loads(size)
            size = dict(size)

            for tag in tags:
                if size[tag] is None:
                    size[tag] = 0.0
                else:
                    size[tag] = size[tag][0]
            product = {
                'all': [],
                'skirt': [],
                'pants': [],
                'dress': [],
                'top': []
            }
            for type in types:
                if type == 'all':
                    cursor.execute(all_size_query, (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust']))
                else:
                    cursor.execute(type_size_query, (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust'], type))
                result = cursor.fetchall()
                colnames = DBMapping.mapping_column(cursor)
                for item in result:
                    load = ProductModel()
                    load.fetch_data(item, colnames)
                    product[type].append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return 'None'


def get_type_clothes_sf(type):
    with db_connect() as (service_conn, cursor):
        tags = ['waist', 'hip', 'thigh', 'shoulder', 'bust']
        try:
            size = select_user_size()
            size = json.loads(size)
            size = dict(size)
            for tag in tags:
                if size[tag] is None:
                    size[tag] = 0.0
                else:
                    size[tag] = size[tag][0]
            if type == 'all':
                cursor.execute(all_size_query, (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust']))
            else:
                cursor.execute(type_size_query, (size['waist'], size['hip'], size['thigh'], size['shoulder'], size['bust'], type))
            result = cursor.fetchall()
            product = []
            colnames = DBMapping.mapping_column(cursor)
            for item in result:
                load = ProductModel()
                load.fetch_data(item, colnames)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return 'None'


def get_clothes_category(type):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND type = %s AND p.active_flag = True ORDER BY random() LIMIT 10"""
        all_query = """SELECT * FROM Products p, Shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True ORDER BY random() LIMIT 10"""
        try:
            if type == 'all':
                cursor.execute(all_query)
            else:
                cursor.execute(query, (type,))
            result = cursor.fetchall()
            product = []
            colnames = DBMapping.mapping_column(cursor)
            for item in result:
                load = ProductModel()
                load.fetch_data(item, colnames)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass
        return 'None'


def get_recommended_product(products):
    with db_connect() as (service_conn, cursor):
        if len(products) >= 6:
            non_preferred_item = products[-5:]
            products = products[:-5]
        else:
            return 'Empty'
        query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True AND product_id IN %s"""
        try:
            product = []
            cursor.execute(query, (tuple(products), ))
            result = cursor.fetchall()
            cursor.execute(query, (tuple(non_preferred_item),))
            result += cursor.fetchall()
            colnames = DBMapping.mapping_column(cursor)
            for item in result:
                load = ProductModel()
                load.fetch_data(item, colnames)
                product.append(load.__dict__)
            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as ex:
            print(ex)
            pass


# def get_recommended_product_all(products):
#     with db_connect() as (service_conn, cursor):
#         query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND product_id IN %s"""
#         try:
#             items = []
#             types = ['top', 'dress', 'pants', 'skirt']
#             product = {
#                 'all': [],
#                 'skirt': [],
#                 'pants': [],
#                 'dress': [],
#                 'top': []
#             }
#             cursor.execute(query, (tuple(products), ))
#             result = cursor.fetchall()
#             for item in result:
#                 load = ProductModel()
#                 load.fetch_data(item)
#                 product[load.__dict__['type']].append(load.__dict__)
#                 items.append(load.__dict__)
#             # for item['']
#             for type in types:
#                 product['all'] += (product[type][0:3])
#                 del product[type][0:3]
#             return json.dumps(product, default=json_util.default, ensure_ascii=False)
#         except Exception as ex:
#             print(ex)
#             pass

def get_recommended_product_all(products):
    with db_connect() as (service_conn, cursor):
        query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True AND p.product_id IN %s"""
        try:
            types = ['top', 'dress', 'pants', 'skirt', 'all']
            product = {
                'all': [],
                'skirt': [],
                'pants': [],
                'dress': [],
                'top': []
            }
            for type in types:
                if len(products[type]) >= 6:
                    non_preferred_item = products[type][-5:]
                    preferred_item = products[type][:-5]
                else:
                    return 'Empty'
                cursor.execute(query, (tuple(preferred_item),))
                result = cursor.fetchall()
                cursor.execute(query, (tuple(non_preferred_item), ))
                result += cursor.fetchall()
                colnames = DBMapping.mapping_column(cursor)
                for item in result:
                    load = ProductModel()
                    load.fetch_data(item, colnames)
                    product[type].append(load.__dict__)

            return json.dumps(product, default=json_util.default, ensure_ascii=False)
        except Exception as Ex:
            print(Ex)
            pass


def check_like_cnt():
    with db_connect() as (service_conn, cursor):
        query = """SELECT count(*) FROM evaluation WHERE user_id = %s AND likes is True"""
        update_query = """UPDATE users SET recommendation_flag = True WHERE user_id = %s"""
        try:
            cursor.execute(query, (g.user_id, ))
            cnt = cursor.fetchone()[0]
            if cnt >= 5:
                cursor.execute(update_query, (g.user_id, ))
                service_conn.commit()
                return True
            else:
                return False
        except Exception as ex:
            print(ex)
            pass


def get_mock_product_list():
    with db_connect() as (service_conn, cursor):
        mock_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True ORDER BY random() LIMIT 20"""
        eval_query = """SELECT * FROM evaluation WHERE user_id = %s AND product_id IN %s"""
        get_list_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True AND p.product_id IN %s"""
        cursor.execute(mock_query)
        result = cursor.fetchall()
        product = []
        product_eval = {}
        product_id = []
        # ES MOCK product_id
        colnames = DBMapping.mapping_column(cursor)
        for item in result:
            load = ProductModel()
            load.fetch_data(item, colnames)
            product_id.append(load.__dict__['product_id'])
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
            product.append(load.__dict__)

        return json.dumps(product, default=json_util.default, ensure_ascii=False)


def get_product_list(recommend_list):
    with db_connect() as (service_conn, cursor):
        eval_query = """SELECT * FROM evaluation WHERE user_id = %s AND product_id IN %s"""
        get_list_query = """SELECT * FROM products p, shop s WHERE p.shop_id = s.shop_id AND p.active_flag = True AND p.product_id IN %s"""

        product = []
        product_eval = {}
        product_id = recommend_list

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
            product.append(load.__dict__)

        return json.dumps(product, default=json_util.default, ensure_ascii=False)