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
        SELECT evaluation.user_id, shop.shop_id, products.product_id, products.type, shop.shop_concept
        FROM evaluation join products using (product_id) join shop using (shop_id)
        WHERE evaluation.likes = true and evaluation.es_flag = false;
    """)
    like_items = db_cursor.fetchall()
    docs = [{'user_id': item[0], 'shop_id': str(item[1]), 'product_id': str(item[2]), 'clothes_type': item[3],
             'shop_concept': item[4], 'rating': 'like'} for item in like_items]
    db_cursor.close()
    return docs


def get_dislike_items_documents():
    db_cursor = conn.cursor()
    db_cursor.execute("""
        SELECT evaluation.user_id, shop.shop_id, products.product_id, products.type, shop.shop_concept
        FROM evaluation join products using (product_id) join shop using (shop_id)
        WHERE evaluation.likes = false and evaluation.es_flag = false;
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
        SELECT product_id, shop.shop_id, type, length::float4[], waist::float4[], hip::float4[], thigh::float4[], 
            rise::float4[], hem::float4[], shoulder::float4[], bust::float4[], arm_length::float4[], 
            price, clustered_color as color, shop_concept
        FROM products join shop using (shop_id)
        WHERE active_flag = true and es_flag = false;
    """)
    products = db_cursor.fetchall()
    db_cursor.close()
    return products


def update_es_flag_products_table(product_id):
    db_cursor = conn.cursor()
    db_cursor.execute("""
        UPDATE products
        SET es_flag = true
        WHERE products.product_id in %s """ % (product_id,))
    db_cursor.close()
    conn.commit()


def update_evaluation_table_es_flag(like, product_ids):
    db_cursor = conn.cursor()
    if like:
        db_cursor.execute("""UPDATE evaluation SET es_flag = true WHERE likes = true and product_id in %s""", (product_ids,))
    else:
        db_cursor.execute("""UPDATE evaluation SET es_flag = true WHERE likes = false and product_id in %s""", (product_ids,))
    db_cursor.close()
    conn.commit()


# this function returns an array of str(product_id) for a given user and clothes type
def get_like_items_of_user(user_id, clothes_type):
    db_cursor = conn.cursor()
    db_cursor.execute("""
            SELECT ARRAY(
            SELECT p.product_id::varchar(255)
            FROM products p JOIN evaluation l USING (product_id)
            WHERE l.user_id = %s and p.type = %s and l.likes = true);
        """, (user_id, clothes_type))
    user_rated_items = db_cursor.fetchone()[0]
    db_cursor.close()
    return user_rated_items


def get_user_size_data(user_id):
    db_cursor = conn.cursor()
    user_size_dict = {}
    db_cursor.execute(
        """
        SELECT length::float4[], waist::float4[], hip::float4[] as hip, thigh::float4[] as thigh, 
                rise::float4[], hem::float4[], shoulder::float4[], bust::float4[], arm_length::float4[]
        FROM users
        WHERE user_id = %s
        """, (user_id,)
    )
    user_size_data = db_cursor.fetchone()
    for size_type_index in range(len(size_types)):
        user_size_dict[size_types[size_type_index]] = user_size_data[size_type_index] if user_size_data[size_type_index] else [0]
    db_cursor.close()
    return user_size_dict


def get_user_shop_concepts(user_id):
    db_cursor = conn.cursor()
    db_cursor.execute("""SELECT shop_concept FROM users WHERE user_id = %s""", (user_id,))
    shop_concepts = db_cursor.fetchone()[0]
    db_cursor.close()
    return shop_concepts


def get_entire_user_seen_items_from_db(user_id):
    db_cursor = conn.cursor()
    query = """select array(select evaluation.product_id::varchar(255)
        from evaluation join products using (product_id) 
        where user_id = %s)"""
    db_cursor.execute(query, (user_id, ))
    items = db_cursor.fetchone()[0]
    db_cursor.close()
    return items


def get_clothes_type_items_shown_to_user_from_db(user_id, clothes_type):
    db_cursor = conn.cursor()
    query = """select array(select evaluation.product_id::varchar(255)
        from evaluation join products using (product_id) 
        where user_id = %s and products.type = %s)"""
    db_cursor.execute(query, (user_id, clothes_type))
    items = db_cursor.fetchone()[0]
    db_cursor.close()
    return items


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


def get_user_preferred_concept_shops_from_db(user_id):
    user_concepts = get_user_shop_concepts(user_id)
    db_cursor = conn.cursor()
    query = """
    SELECT ARRAY(
    SELECT s.shop_id
    FROM shop s, LATERAL (
        SELECT count(*) AS ct
        FROM   unnest(s.shop_concept) sc
        WHERE  sc = ANY(%s)
    ) x
    ORDER  BY x.ct DESC);
    """
    db_cursor.execute(query, (user_concepts,))
    res = db_cursor.fetchone()[0]
    db_cursor.close()
    return res


def get_clothes_type_popular_items_from_db(clothes_type):
    db_cursor = conn.cursor()
    query = """select ARRAY(select product_id::varchar(255) from likes join products using (product_id) where type = %s 
    group by product_id order by count(product_id) desc limit 10)"""
    db_cursor.execute(query, (clothes_type,))
    result = db_cursor.fetchone()[0]
    db_cursor.close()
    return result


def get_all_type_popular_items_from_db():
    db_cursor = conn.cursor()
    query = """select ARRAY(select product_id::varchar(255) from likes join products using (product_id) 
        group by product_id order by count(product_id) desc limit 10)"""
    db_cursor.execute(query)
    result = db_cursor.fetchone()[0]
    db_cursor.close()
    return result


def get_update_user_ids_from_db():
    db_cursor = conn.cursor()
    query = """select array(select user_id from users where last_login_at >= now() - INTERVAL '1 DAY');"""
    db_cursor.execute(query)
    result = db_cursor.fetchone()[0]
    db_cursor.close()
    return result


def count_user_liked_items_from_db(user_id):
    db_cursor = conn.cursor()
    query = """select count(product_id) from likes where user_id = %s"""
    db_cursor.execute(query, (user_id,))
    result = db_cursor.fetchone()
    db_cursor.close()
    return result[0]


def get_clothes_type_non_preferred_items_from_db(non_pref_shops, clothes_type):
    db_cursor = conn.cursor()
    query = """select ARRAY(select products.product_id::varchar(255) from products join shop using (shop_id) 
    where shop.shop_id in %s and type = %s order by random() limit 5)"""
    db_cursor.execute(query, (tuple(non_pref_shops), clothes_type))
    result = db_cursor.fetchone()[0]
    db_cursor.close()
    return result


def get_all_type_non_preferred_items_from_db(non_pref_shops):
    db_cursor = conn.cursor()
    query = """select ARRAY (select product_id::varchar(255) from products join shop using (shop_id) 
    where shop_id in %s order by random() limit 5)"""
    db_cursor.execute(query, (tuple(non_pref_shops), ))
    result = db_cursor.fetchone()[0]
    db_cursor.close()
    return result


def get_invalid_products_in_es():
    db_cursor = conn.cursor()
    query = """select array(select product_id::varchar(255) from products where active_flag = false and es_flag = true)"""
    db_cursor.execute(query)
    result = db_cursor.fetchone()[0]
    db_cursor.close()
    return result


def update_user_concepts(user_id, concepts):
    db_cursor = conn.cursor()
    try:
        db_cursor.execute("""UPDATE users SET shop_concept = %s WHERE user_id = %s """, (concepts, user_id))
        conn.commit()
    except Exception as e:
        print(e)
        conn.rollback()
    finally:
        db_cursor.close()


def get_off_season_items():
    off_season_keywords = ('반팔', '숏팬츠','나시', '슬리브리스', '슬리브', '썸머', '린넨', '쿨', '여름', '반바지', '숏데님', '쇼츠', '4부', 'half', '하프', 'linen')
    remove_items = []
    with conn.cursor() as db_cursor:
        try:
            for k in off_season_keywords:
                like_pattern = '%{}%'.format(k)
                query = """select array(select product_id::varchar(255) from products where product_name like %s)"""
                db_cursor.execute(query, (like_pattern,))
                items = db_cursor.fetchone()[0]
                remove_items += items
            return remove_items
        except Exception as e:
            print(e)
            conn.rollback()
        finally:
            db_cursor.close()
