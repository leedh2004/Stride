import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
from elasticsearch import helpers
import backend.recommendation.queries as queries

es = es_connection

size_types_dict = {'length': 3, 'waist': 4, 'hip': 5, 'thigh': 6, 'rise': 7,
                   'hem': 8, 'shoulder': 9, 'bust': 10, 'arm_length': 11}


def insert_size_values(doc, size_tag, size_info):
    NO_SIZE_DATA = 200.0
    if not size_info:
        doc['max_' + size_tag] = NO_SIZE_DATA
        doc['min_' + size_tag] = NO_SIZE_DATA
    else:
        doc['max_' + size_tag] = max(size_info)
        doc['min_' + size_tag] = min(size_info)


def create_product_document(product_info):
    doc = {'product_id': str(product_info[0]), 'shop_id': str(product_info[1]), 'clothes_type': product_info[2]}
    for size_type in size_types_dict:
        insert_size_values(doc, size_type, product_info[size_types_dict[size_type]])
    return doc


# this function should be run periodically in crawling process to get sync between es and service db
def index_product_documents():
    products_info = queries.get_new_products_from_db()
    docs = []
    product_ids = []
    for product in products_info:
        doc = create_product_document(product)
        docs.append(
            {
                '_index': 'products',
                '_id': str(doc['product_id']),
                '_source': doc
            }
        )
        product_ids.append(int(doc['product_id']))
    try:
        if docs:
            print(docs)
            helpers.bulk(es, docs)
            es.indices.refresh()
            queries.update_es_flag_products_table(tuple(product_ids))
    except Exception as e:
        print(e)


# this function indexes user_ratings into user_ratings and user_rated_items indices
def index_user_rating_data():
    docs = []
    for preference in ('likes', 'pass', 'dislikes'):
        # for each user who has updates
        for user in index_user_rating(preference):
            docs.append(
                {
                    '_index': 'user_rated_items',
                    '_id': user + preference + 'top',
                    '_source': get_user_rated_items(user, preference, 'top')
                }
            )
            docs.append(
                {
                    '_index': 'user_rated_items',
                    '_id': user + preference + 'dress',
                    '_source': get_user_rated_items(user, preference, 'dress')
                }
            )
            docs.append(
                {
                    '_index': 'user_rated_items',
                    '_id': user + preference + 'skirt',
                    '_source': get_user_rated_items(user, preference, 'skirt')
                }
            )
            docs.append(
                {
                    '_index': 'user_rated_items',
                    '_id': user + preference + 'pants',
                    '_source': get_user_rated_items(user, preference, 'pants')
                }
            )
    try:
        if docs:
            print(docs)
            helpers.bulk(es, docs)
            es.indices.refresh()
    except Exception as e:
        print(e)


def index_user_rated_items(users):
    docs = []
    for preference in ('likes', 'pass', 'dislikes'):
        # for each user who has updates
        for user in users:
            docs.append(
                {
                    '_index': 'user_rated_items',
                    '_id': user + preference + 'top',
                    '_source': get_user_rated_items(user, preference, 'top')
                }
            )
            docs.append(
                {
                    '_index': 'user_rated_items',
                    '_id': user + preference + 'dress',
                    '_source': get_user_rated_items(user, preference, 'dress')
                }
            )
            docs.append(
                {
                    '_index': 'user_rated_items',
                    '_id': user + preference + 'skirt',
                    '_source': get_user_rated_items(user, preference, 'skirt')
                }
            )
            docs.append(
                {
                    '_index': 'user_rated_items',
                    '_id': user + preference + 'pants',
                    '_source': get_user_rated_items(user, preference, 'pants')
                }
            )
    try:
        if docs:
            print(docs)
            helpers.bulk(es, docs)
            es.indices.refresh()
    except Exception as e:
        print(e)


def index_user_rating(preference):
    docs = []
    product_ids = []
    updated_users_list = set()
    if preference == 'likes':
        items = queries.get_like_items_documents()
    elif preference == 'pass':
        items = queries.get_pass_items_documents()
    else:
        items = queries.get_dislike_items_documents()
    for item in items:
        if item is not None:
            updated_users_list.add(item['user_id'])
            docs.append(
                {
                    '_index': 'user_ratings',
                    '_id': item['user_id'] + item['product_id'],
                    '_source': item
                }
            )
            product_ids.append(int(item['product_id']))
    try:
        if docs:
            print(docs)
            helpers.bulk(es, docs)
            es.indices.refresh()
            queries.update_es_flag_rating_tables(preference, tuple(product_ids))
        return updated_users_list
    except Exception as e:
        print(e)


def get_user_rated_items(user_id, preference, clothes_type):
    if preference == 'likes':
        user_like_items = [str(item[0]) for item in queries.get_like_items_of_user(user_id, clothes_type)]
        return {'user_id': user_id, 'product_id': user_like_items, 'rating': 'like', 'clothes_type': clothes_type}
    elif preference == 'pass':
        user_pass_items = [str(item[0]) for item in queries.get_pass_items_of_user(user_id, clothes_type)]
        return {'user_id': user_id, 'product_id': user_pass_items, 'rating': 'pass', 'clothes_type': clothes_type}
    elif preference == 'dislikes':
        user_dislike_items = [str(item[0]) for item in queries.get_dislike_items_of_user(user_id, clothes_type)]
        return {'user_id': user_id, 'product_id': user_dislike_items, 'rating': 'dislike', 'clothes_type': clothes_type}


# this function removes from es invalid items whose active_flag turned false in db
# this function should be called after indexing products to get sync with db
def remove_invalid_items():
    invalid_product_ids = queries.get_invalid_products_in_es()
    es.delete_by_query(index='products', body={
        "query": {
            "terms": {
                "product_id": invalid_product_ids
            }
        }
    })
