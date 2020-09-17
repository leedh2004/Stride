import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
import psycopg2 as pg2

conn = pg2.connect(dbname=db_name, user=db_user, password=db_password,
                   host=db_host, port=db_port)


size_types = ('length', 'waist', 'hip', 'thigh', 'rise', 'hem', 'shoulder', 'bust', 'arm_length')


def get_like_items_documents():
    db_cursor = conn.cursor()
    db_cursor.execute("""
        SELECT likes.user_id, shop.shop_id, products.product_id, products.type, shop.shop_concept
        FROM likes join products using (product_id) join shop using (shop_id)
        WHERE likes.es_flag = false;
    """)
    like_items = db_cursor.fetchall()
    docs = [{'user_id': item[0], 'shop_id': str(item[1]), 'product_id': str(item[2]), 'clothes_type': item[3], 'shop_concept': item[4],
             'rating': 'like', 'preference_score': 0.0} for item in like_items]
    db_cursor.close()
    return docs


def get_pass_items_documents():
    db_cursor = conn.cursor()
    db_cursor.execute("""
        SELECT pass.user_id, shop.shop_id, products.product_id, products.type, shop.shop_concept
        FROM pass join products using (product_id) join shop using (shop_id)
        WHERE pass.es_flag = false;
    """)
    pass_items = db_cursor.fetchall()
    docs = [{'user_id': item[0], 'shop_id': str(item[1]), 'product_id': str(item[2]), 'clothes_type': item[3],
             'shop_concept': item[4], 'rating': 'pass', 'preference_score': 0.0} for item in pass_items]
    db_cursor.close()
    return docs


def get_dislike_items_documents():
    db_cursor = conn.cursor()
    db_cursor.execute("""
        SELECT dislikes.user_id, shop.shop_id, products.product_id, products.type, shop.shop_concept
        FROM dislikes join products using (product_id) join shop using (shop_id)
        WHERE dislikes.es_flag = false;
    """)
    dislike_items = db_cursor.fetchall()
    docs = [{'user_id': item[0], 'shop_id': str(item[1]), 'product_id': str(item[2]), 'clothes_type': item[3],
             'shop_concept': item[4], 'rating': 'dislike', 'preference_score': 0.0} for item in dislike_items]
    db_cursor.close()
    return docs


def get_shop_concepts_from_shop_id(shop_id):
    db_cursor = conn.cursor()
    db_cursor.execute(f"""
        SELECT shop_concept
        FROM shop
        WHERE shop_id = {shop_id};
    """)
    shop_concept = db_cursor.fetchone()[0]
    db_cursor.close()
    return shop_concept


def get_products_from_shop_id(shop_id):
    db_cursor = conn.cursor()
    db_cursor.execute(f"""
        SELECT product_id
        FROM products
        WHERE shop_id = {shop_id};
    """)
    products = db_cursor.fetchall()
    shop_products = [str(prod[0]) for prod in products]
    db_cursor.close()
    return shop_products


def get_new_products_from_db():
    db_cursor = conn.cursor()
    db_cursor.execute(f"""
        SELECT product_id, shop_id, type, length::float4[], waist::float4[], hip::float4[], thigh::float4[], 
            rise::float4[], hem::float4[], shoulder::float4[], bust::float4[], arm_length::float4[]
        FROM products
        WHERE active_flag = true and es_flag = false;
    """)
    products = db_cursor.fetchall()
    db_cursor.close()
    return products


# update es_flag for both products and user behavior tables
def update_es_flag_products_table(product_id):
    db_cursor = conn.cursor()
    db_cursor.execute("""
        UPDATE products
        SET es_flag = true
        WHERE products.product_id in %s """ % (product_id,))
    db_cursor.close()
    conn.commit()


def update_es_flag_rating_tables(preference, product_ids):
    db_cursor = conn.cursor()
    if preference == 'likes':
        db_cursor.execute("""UPDATE likes SET es_flag = True WHERE likes.product_id in %s""" % (product_ids,))
    elif preference == 'pass':
        db_cursor.execute("""UPDATE pass SET es_flag = True WHERE pass.product_id in %s""" % (product_ids,))
    elif preference == 'dislikes':
        db_cursor.execute("""UPDATE dislikes SET es_flag = True WHERE dislikes.product_id in %s""" % (product_ids,))
    db_cursor.close()
    conn.commit()


def get_like_items_of_user(user_id, clothes_type):
    db_cursor = conn.cursor()
    db_cursor.execute("""
            SELECT p.product_id 
            FROM products p JOIN likes l ON (p.product_id = l.product_id)
            WHERE l.user_id = '%s' and p.es_flag = true and p.type = '%s';
        """ % (user_id, clothes_type))
    user_rated_items = db_cursor.fetchall()
    db_cursor.close()
    return user_rated_items


def get_pass_items_of_user(user_id, clothes_type):
    db_cursor = conn.cursor()
    db_cursor.execute("""
            SELECT products.product_id 
            FROM products JOIN pass ON (products.product_id = pass.product_id)
            WHERE pass.user_id = '%s' and products.es_flag = true and products.type = '%s';
        """ % (user_id, clothes_type))
    user_rated_items = db_cursor.fetchall()
    db_cursor.close()
    return user_rated_items


def get_dislike_items_of_user(user_id, clothes_type):
    db_cursor = conn.cursor()
    db_cursor.execute("""
            SELECT products.product_id 
            FROM products JOIN dislikes ON (products.product_id = dislikes.product_id)
            WHERE dislikes.user_id = '%s' and products.es_flag = true and products.type = '%s';
        """ % (user_id, clothes_type))
    user_rated_items = db_cursor.fetchall()
    db_cursor.close()
    return user_rated_items


def get_user_size_data(user_id):
    db_cursor = conn.cursor()
    user_size_dict = {}
    db_cursor.execute(
        f"""
        SELECT length::float4[], waist::float4[], hip::float4[] as hip, thigh::float4[] as thigh, 
                rise::float4[], hem::float4[], shoulder::float4[], bust::float4[], arm_length::float4[]
        FROM users
        WHERE user_id = '{user_id}'
        """
    )
    user_size_data = db_cursor.fetchone()
    for size_type_index in range(len(size_types)):
        user_size_dict[size_types[size_type_index]] = user_size_data[size_type_index] if user_size_data[size_type_index] else [0]
    db_cursor.close()
    return user_size_dict


def get_user_tutorial_shop_concepts(user_id):
    db_cursor = conn.cursor()
    db_cursor.execute(f"""
        SELECT shop_concept FROM users WHERE user_id = '{user_id}'""")
    shop_concepts = db_cursor.fetchone()[0]
    db_cursor.close()
    return shop_concepts


def get_entire_user_seen_items_from_db(user_id):
    db_cursor = conn.cursor()
    query = """select product_id from likes where user_id = %s
    UNION DISTINCT select product_id from dislikes where user_id = %s 
    UNION DISTINCT select product_id from pass where user_id = %s"""
    db_cursor.execute(query, (user_id, user_id, user_id))
    items = db_cursor.fetchall()
    result = [str(item[0]) for item in items]
    db_cursor.close()
    return result


def get_clothes_type_items_shown_to_user_from_db(user_id, clothes_type):
    db_cursor = conn.cursor()
    query = """select products.product_id from products where type = %s and product_id in 
    (select product_id from likes where user_id = %s UNION DISTINCT select product_id from dislikes where user_id = %s 
    UNION DISTINCT select product_id from pass where user_id = %s)"""
    db_cursor.execute(query, (clothes_type, user_id, user_id, user_id))
    items = db_cursor.fetchall()
    result = [str(item[0]) for item in items]
    db_cursor.close()
    return result


def get_user_liked_shop_concepts_from_db(user_id):
    shop_concepts_with_weight = {'basic': 0.3, 'daily': 0.3, 'simple': 0.6, 'chic': 0.7, 'street': 0.6, 'romantic': 0.7,
                                 'unique': 0.8, 'sexy': 0.7, 'vintage': 0.7}
    shop_concept_counts = {'basic': 0, 'daily': 0, 'simple': 0, 'chic': 0, 'street': 0,
                           'romantic': 0, 'unique': 0, 'sexy': 0, 'vintage': 0}
    db_cursor = conn.cursor()
    query = """select count(shop_id), shop_concept 
    from (products join likes using (product_id)) join shop using (shop_id) 
    where user_id = %s group by shop_id, shop_concept;"""
    db_cursor.execute(query, (user_id,))
    results = db_cursor.fetchall()
    for result in results:
        count = result[0]
        shop_concepts = result[1]
        for shop_concept in shop_concepts:
            shop_concept_counts[shop_concept] += count
    for shop_concept in shop_concepts_with_weight:
        shop_concepts_with_weight[shop_concept] *= shop_concept_counts[shop_concept]
    concept_dict = {k: v for k, v in sorted(shop_concepts_with_weight.items(), key=lambda item: item[1], reverse=True)}
    preferred_shop_concepts = [k for k in concept_dict.keys()]
    db_cursor.close()
    return preferred_shop_concepts


def get_recommended_shops_by_user_preferred_concepts_from_db(user_id):
    user_preferred_concepts = get_user_liked_shop_concepts_from_db(user_id)
    db_cursor = conn.cursor()
    recommended_shops = set()
    query = """select shop_id from shop where %s = ANY(shop_concept)"""
    db_cursor.execute(query, (user_preferred_concepts[0],))
    best_concept_matched_shops = {str(shop_id[0]) for shop_id in db_cursor.fetchall()}
    db_cursor.execute(query, (user_preferred_concepts[1],))
    second_concept_matched_shops = {str(shop_id[0]) for shop_id in db_cursor.fetchall()}
    db_cursor.execute(query, (user_preferred_concepts[2],))
    third_concept_matched_shops = {str(shop_id[0]) for shop_id in db_cursor.fetchall()}
    recommended_shops = recommended_shops.union(best_concept_matched_shops.intersection(second_concept_matched_shops))
    recommended_shops = recommended_shops.union(best_concept_matched_shops.intersection(third_concept_matched_shops))
    recommended_shops = recommended_shops.union(second_concept_matched_shops.intersection(third_concept_matched_shops))
    db_cursor.close()
    return list(recommended_shops)


def get_clothes_type_popular_items_from_db(clothes_type):
    db_cursor = conn.cursor()
    query = """select product_id from likes join products using (product_id) where type = %s 
    group by product_id order by count(product_id) desc limit 10"""
    db_cursor.execute(query, (clothes_type,))
    result = db_cursor.fetchall()
    popular_items = [str(r[0]) for r in result]
    db_cursor.close()
    return popular_items


def get_all_type_popular_items_from_db():
    db_cursor = conn.cursor()
    query = """select product_id from likes join products using (product_id) 
        group by product_id order by count(product_id) desc limit 10"""
    db_cursor.execute(query)
    result = db_cursor.fetchall()
    popular_items = [str(r[0]) for r in result]
    db_cursor.close()
    return popular_items


def get_entire_user_ids_from_db():
    db_cursor = conn.cursor()
    query = """select user_id from users"""
    db_cursor.execute(query)
    result = db_cursor.fetchall()
    popular_items = [r[0] for r in result]
    db_cursor.close()
    return popular_items


def count_user_liked_items_from_db(user_id):
    db_cursor = conn.cursor()
    query = """select count(product_id) from likes where user_id = %s"""
    db_cursor.execute(query, (user_id,))
    result = db_cursor.fetchone()
    db_cursor.close()
    return result[0]


def get_clothes_type_non_preferred_items_from_db(preferred_shops, clothes_type):
    db_cursor = conn.cursor()
    preferred_shops = tuple(preferred_shops)
    query = """select products.product_id from products join shop using (shop_id) 
    where shop.shop_id not in %s and type = %s order by random() limit 5"""
    db_cursor.execute(query, (preferred_shops, clothes_type))
    result = db_cursor.fetchall()
    non_preferred_items = [str(item[0]) for item in result]
    db_cursor.close()
    return non_preferred_items


def get_all_type_non_preferred_items_from_db(preferred_shops):
    db_cursor = conn.cursor()
    preferred_shops = tuple(preferred_shops)
    query = """select product_id from products join shop using (shop_id) 
    where shop_id not in %s order by random() limit 5"""
    db_cursor.execute(query, (preferred_shops, ))
    result = db_cursor.fetchall()
    non_preferred_items = [str(item[0]) for item in result]
    db_cursor.close()
    return non_preferred_items
