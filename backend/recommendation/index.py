import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
import backend.recommendation.queries as queries
import backend.recommendation.analyze as analyze
es = es_connection

size_types_dict = {'length': 3, 'waist': 4, 'hip': 5, 'thigh': 6, 'rise': 7,
                   'hem': 8, 'shoulder': 9, 'bust': 10, 'arm_length': 11}


# this function should be run periodically in crawling process to get sync between es and service db
# 200 means product data does not exist
def index_product_documents():
    products_info = queries.get_new_products_from_db()
    for product in products_info:
        doc = create_product_document(product)
        print(doc)
        es.index(index='products', body=doc, id=doc['product_id'])
        queries.update_es_flag_products_table(int(doc['product_id']))


# this function indexes user_ratings into user_ratings and user_rated_items indices
def index_user_rating_data():
    for preference in ('likes', 'pass', 'dislikes'):
        # for each user who has updates
        for user in index_user_rating(preference):
            index_user_rated_items(user, preference, 'top')
            index_user_rated_items(user, preference, 'dress')
            index_user_rated_items(user, preference, 'skirt')
            index_user_rated_items(user, preference, 'pants')


def index_user_rating(preference):
    updated_users_list = set()
    if preference == 'likes':
        items = queries.get_like_items()
    elif preference == 'pass':
        items = queries.get_pass_items()
    else:
        items = queries.get_dislike_items()
    for item in items:
        doc = create_user_rating_document(item[0], str(item[1]), preference)
        if doc is not None:
            print('inserting user rating:', doc)
            updated_users_list.add(doc['user_id'])
            es.index(index='user_ratings', body=doc, id=doc['user_id'] + doc['product_id'])
            queries.update_es_flag_rating_tables(preference, int(doc['product_id']))
    return updated_users_list


def create_user_rating_document(user_id, product_id, preference):
    product_info = analyze.get_product_extra_info(product_id)
    if product_info is None:
        return None
    document = {'user_id': user_id, 'product_id': product_id, 'shop_id': product_info['shop_id'],
                'clothes_type': product_info['clothes_type'], 'rating': preference, 'preference_score': 0.0}
    shop_concept = queries.get_shop_concepts_from_shop_id(document['shop_id'])
    document['shop_concept'] = shop_concept
    return document


def create_product_document(product_info):
    doc = {'product_id': str(product_info[0]), 'shop_id': str(product_info[1]), 'clothes_type': product_info[2]}
    for size_type in size_types_dict:
        insert_size_values(doc, size_type, product_info[size_types_dict[size_type]])
    return doc


def insert_size_values(doc, size_tag, size_info):
    NO_SIZE_DATA = 200.0
    if not size_info:
        doc['max_' + size_tag] = NO_SIZE_DATA
        doc['min_' + size_tag] = NO_SIZE_DATA
    else:
        doc['max_' + size_tag] = max(size_info)
        doc['min_' + size_tag] = min(size_info)


def index_user_rated_items(user_id, preference, clothes_type):
    if preference == 'likes':
        user_like_items = [item[0] for item in queries.get_like_items_of_user(user_id, clothes_type)]
        document = {'user_id': user_id, 'product_id': user_like_items, 'rating': 'like', 'clothes_type': clothes_type}
        print(document)
        es.index(index='user_rated_items', body=document, id=user_id + 'like')
    elif preference == 'pass':
        user_pass_items = [item[0] for item in queries.get_pass_items_of_user(user_id, clothes_type)]
        document = {'user_id': user_id, 'product_id': user_pass_items, 'rating': 'pass', 'clothes_type': clothes_type}
        print(document)
        es.index(index='user_rated_items', body=document, id=user_id + 'pass')
    elif preference == 'dislikes':
        user_dislike_items = [item[0] for item in queries.get_dislike_items_of_user(user_id, clothes_type)]
        document = {'user_id': user_id, 'product_id': user_dislike_items, 'rating': 'dislike', 'clothes_type': clothes_type}
        print(document)
        es.index(index='user_rated_items', body=document, id=user_id + 'dislike')
