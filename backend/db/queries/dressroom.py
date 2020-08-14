from flask import g
from backend.db.init import *
from bson import json_util
import json


def delete_dressroom(product_id):
    cursor = service_conn.cursor()
    query = """DELETE FROM dressroom where user_id = %s::varchar and product_id = %s::int"""
    try:
        for del_id in product_id:
            cursor.execute(query, (g.user_id, del_id))
            service_conn.commit()
    except:
        service_conn.rollback()
        raise
        pass
    cursor.close()


def get_dressroom():
    cursor = service_conn.cursor()
    query = """SELECT * FROM products p, dressroom d WHERE p.product_id = d.product_id AND user_id = %s ORDER BY created_at ASC"""
    try:
        cursor.execute(query, (g.user_id, ))
        result = cursor.fetchall()
        print(result)
        print('len', len(result))
        product = []
        for item in result:
            load = {}
            load['product_id'] = item[0]
            load['product_url'] = item[3]
            load['product_name'] = item[4]
            load['price'] = item[5]
            load['thumbnail_url'] = item[6]
            load['type'] = item[8]
            product.append(load)
        cursor.close()
        print(product)
        return json.dumps(product, default=json_util.default, ensure_ascii=False)
    except:
        pass

