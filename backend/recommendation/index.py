import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
from elasticsearch import helpers
import backend.recommendation.queries as queries


size_types_dict = {'length': 3, 'waist': 4, 'hip': 5, 'thigh': 6, 'rise': 7,
                   'hem': 8, 'shoulder': 9, 'bust': 10, 'arm_length': 11}

clothes_types = ('outer', 'top', 'pants', 'skirt', 'dress')


def insert_size_values(doc, size_tag, size_info):
    NO_SIZE_DATA = 200.0
    if not size_info:
        doc['max_' + size_tag] = NO_SIZE_DATA
        doc['min_' + size_tag] = NO_SIZE_DATA
    else:
        doc['max_' + size_tag] = max(size_info)
        doc['min_' + size_tag] = min(size_info)


def create_product_document(product_info):
    doc = {'product_id': str(product_info[0]), 'shop_id': str(product_info[1]), 'clothes_type': product_info[2],
           'price': product_info[12], 'color': product_info[13], 'shop_concept': product_info[14]}
    for size_type in size_types_dict:
        insert_size_values(doc, size_type, product_info[size_types_dict[size_type]])
    return doc


# this function should be run periodically in crawling process to get sync between es and service db
def index_product_documents(es):
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


# this function indexes user_ratings into user_ratings and user_liked_items indices
def index_user_rating_data(es):
    docs = []
    # index like items
    users = index_user_rating(like=True)
    if not users:
        return
    for user in users:
        for clothes_type in clothes_types:
            docs.append(
                {
                    '_index': 'user_like_items',
                    '_id': user + '_' + clothes_type,
                    '_source': get_user_like_items(user, clothes_type)
                }
            )
    try:
        if docs:
            print(docs)
            helpers.bulk(es, docs)
            es.indices.refresh()
    except Exception as e:
        print(e)
    # index dislike items
    index_user_rating(like=False)


def index_user_rating(like, es):
    docs = []
    product_ids = []
    updated_users_list = set()
    if like:
        items = queries.get_like_items_documents()
    else:
        items = queries.get_dislike_items_documents()
    for item in items:
        if item is not None:
            if like:
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
            queries.update_evaluation_table_es_flag(like, tuple(product_ids))
        return updated_users_list
    except Exception as e:
        print(e)


def get_user_like_items(user_id, clothes_type):
    user_like_items = queries.get_like_items_of_user(user_id, clothes_type)
    print(user_like_items)
    shop_concepts = queries.get_user_shop_concepts(user_id)
    return {'user_id': user_id, 'user_preferred_concepts': shop_concepts,
            'product_id': user_like_items, 'clothes_type': clothes_type}


# this function removes from es invalid items whose active_flag turned false in db
# this function should be called after indexing products to get sync with db
def remove_invalid_items(es):
    invalid_product_ids = queries.get_invalid_products_in_es()
    es.delete_by_query(index='products', body={
        "query": {
            "terms": {
                "product_id": invalid_product_ids
            }
        }
    })
