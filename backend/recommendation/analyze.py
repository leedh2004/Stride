import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
import backend.recommendation.queries as queries
import random

es = es_connection

# shop_concepts_with_weight = {'basic': 0.3, 'daily': 0.3, 'simple': 0.6, 'chic': 0.7, 'street': 0.6, 'romantic': 0.7,
#                              'unique': 0.8, 'sexy': 0.7, 'vintage': 0.7}


def get_user_liked_shop_concepts(user_id):
    shop_concepts_with_weight = {'basic': 0.3, 'daily': 0.3, 'simple': 0.6, 'chic': 0.7, 'street': 0.6, 'romantic': 0.7,
                                 'unique': 0.8, 'sexy': 0.7, 'vintage': 0.7}
    res = es.search(
        index="user_ratings",
        body={
            "size": 0,
            "query": {
                "bool": {
                    "filter": {
                        "term": {
                            "user_id": user_id
                        }
                    },
                    "must": [
                        {
                            "term": {
                                "rating": "like"
                            }
                        }
                    ]
                }
            },
            "aggs": {
                "concepts": {
                    "terms": {
                        "field": "shop_concept",
                        "min_doc_count": 2
                    }
                }
            }
        }
    )
    res = res['aggregations']['concepts']['buckets']
    for result_item in res:
        concept_name = result_item['key']
        concept_count = result_item['doc_count']
        shop_concepts_with_weight[concept_name] *= concept_count
    concept_dict = {k: v for k, v in sorted(shop_concepts_with_weight.items(), key=lambda item: item[1], reverse=True)}
    preferred_shop_concepts_with_weight = [k for k in concept_dict.keys()]
    # return top 3 concepts
    return preferred_shop_concepts_with_weight[:3]


# returns 10 most loved items of given clothes category
def get_clothes_type_popular_items(user_id, clothes_type):
    user_seen_items = queries.get_clothes_type_items_shown_to_user_from_db(user_id, clothes_type)
    res = es.search(
        index="user_ratings",
        body={
            "size": 0,
            "query": {
                "bool": {
                    "must": [
                        {
                            "term": {
                                "rating": "like"
                            }
                        },
                        {
                            "term": {
                                "clothes_type": clothes_type
                            }
                        }
                    ],
                    "must_not": {
                        "terms": {
                            "product_id": user_seen_items
                        }
                    }
                }
            },
            "aggs": {
                "group_by_product": {
                    "terms": {
                        "field": "product_id",
                        "size": 10
                    }
                }
            }
        }
    )
    print(res)
    res = res['aggregations']['group_by_product']['buckets']
    popular_items = [item['key'] for item in res]
    return popular_items


def get_all_type_popular_items(user_id):
    user_seen_items = queries.get_entire_user_seen_items_from_db(user_id)
    res = es.search(
        index="user_ratings",
        body={
            "size": 0,
            "query": {
                "bool": {
                    "must": [
                        {
                            "term": {
                                "rating": "like"
                            }
                        }
                    ],
                    "must_not": {
                        "terms": {
                            "product_id": user_seen_items
                        }
                    }
                }
            },
            "aggs": {
                "group_by_product": {
                    "terms": {
                        "field": "product_id",
                        "size": 10
                    }
                }
            }
        }
    )
    print(res)
    res = res['aggregations']['group_by_product']['buckets']
    popular_items = [item['key'] for item in res]
    return popular_items


def get_user_liked_items(user_id):
    res = es.search(
        index="user_ratings",
        body={
            "_source": "product_id",
            "size": 1000,
            "query": {
                "bool": {
                    "filter": [
                        {
                            "term": {
                                "user_id": user_id
                            }
                        },
                        {
                            "term": {
                                "rating": "like"
                            }
                        }
                    ]
                }
            }
        }
    )
    res = res['hits']['hits']
    return [result_item['_source']['product_id'] for result_item in res]


# TODO: replace with Scroll
def get_user_liked_items_from_cf_index(user_id):
    res = es.search(
        index='user_rated_items',
        body={
            "size": 1000,
            "query": {
                "bool": {
                    "filter": [
                        {
                            "term": {
                                "user_id": user_id
                            }
                        },
                        {
                            "term": {
                                "rating": "like"
                            }
                        }
                    ]
                }
            }
        }
    )
    return res['hits']['hits'][0]['_source']['product_id']


def get_entire_items_shown_to_user(user_id):
    res = es.search(
        index='user_ratings',
        body={
            "_source": "product_id",
            "size": 10000,
            "query": {
                "bool": {
                    "filter": [
                        {
                            "term": {
                                "user_id": user_id
                            }
                        }
                    ]
                }
            }
        }
    )
    product_ids = [r['_source']['product_id'] for r in res['hits']['hits']]
    return product_ids


def count_entire_items_shown_to_user(user_id):
    res = es.search(
        index='user_ratings',
        body={
            "size": 0,
            "query": {
                "bool": {
                    "filter": [
                        {
                            "term": {
                                "user_id": user_id
                            }
                        }
                    ]
                }
            },
            "aggs": {
                "product_count": {
                    "cardinality": {
                        "field": "product_id"
                    }
                }
            }
        }
    )
    return res['aggregations']['product_count']['value']


def get_clothes_type_items_shown_to_user(user_id, clothes_type):
    res = es.search(
        index='user_ratings',
        body={
            "_source": "product_id",
            "size": 10000,
            "query": {
                "bool": {
                    "filter": [
                        {
                            "term": {
                                "user_id": user_id
                            }
                        },
                        {
                            "term": {
                                "clothes_type": clothes_type
                            }
                        }
                    ]
                }
            }
        }
    )
    product_ids = [r['_source']['product_id'] for r in res['hits']['hits']]
    return product_ids


# just for data analysis
def show_concept_popularity_by_like_votes():
    res = es.search(
        index="user_ratings",
        body={
            "size": 0,
            "query": {
                "bool": {
                    "filter": {
                        "term": {
                            "rating": "like"
                        }
                    }
                }
            },
            "aggs": {
                "group_by_shop_concept": {
                    "terms": {
                        "field": "shop_concept"
                    }
                }
            }
        }
    )
    res = res['aggregations']['group_by_shop_concept']['buckets']
    shop_concept_vote_dict = {item['key']: item['doc_count'] for item in res}
    total_like_votes = sum(shop_concept_vote_dict.values())
    print(shop_concept_vote_dict)
    print("total likes:", total_like_votes)
    for k in shop_concept_vote_dict:
        print(f"{k}: {round(shop_concept_vote_dict[k] / total_like_votes * 100, 2)}%")


def get_shop_concept_of_product(product_id):
    res = es.search(
        index="user_ratings",
        body={
            "size": 0,
            "query": {
                "bool": {
                    "filter": {
                        "term": {
                            "product_id": product_id
                        }
                    }
                }
            },
            "aggs": {
                "shop_concepts": {
                    "terms": {
                        "field": "shop_concept"
                    }
                }
            }
        }
    )
    return [result_item['key'] for result_item in res['aggregations']['shop_concepts']['buckets']]


# returns shop id and clothes type
def get_product_extra_info(product_id):
    res = es.search(
        index='products',
        body={
            "_source": ["shop_id", "clothes_type"],
            "query": {
                "bool": {
                    "filter": {
                        "term": {
                            "product_id": product_id
                        }
                    }
                }
            }
        }
    )
    return res['hits']['hits'][0]['_source'] if res['hits']['hits'] else None


def get_entire_products_from_shop_es(shop_id):
    res = es.search(
        index='products',
        body={
            "_source": "product_id",
            "size": 1000,
            "query": {
                "bool": {
                    "filter": {
                        "term": {
                            "shop_id": shop_id
                        }
                    }
                }
            }
        }
    )
    return [item['_source']['product_id'] for item in res['hits']['hits']]


# paging 추가해서 patch
def get_products_from_shop_es_with_clothes_type(user_id, shop_ids, clothes_type):
    user_seen_items = queries.get_clothes_type_items_shown_to_user_from_db(user_id, clothes_type)
    res = es.search(
        index='products',
        body={
            "_source": ["shop_id", "product_id"],
            "size": 50,
            "query": {
                "bool": {
                    "filter": [
                        {
                            "terms": {
                                "shop_id": shop_ids
                            }
                        }
                    ],
                    "must": [
                        {
                            "term": {
                                "clothes_type": clothes_type
                            }
                        }
                    ],
                    "must_not": {
                        "terms": {
                            "product_id": user_seen_items
                        }
                    }
                }
            }
        }
    )
    products = [item['_source']['product_id'] for item in res['hits']['hits']]
    return random.sample(products, 20) if len(products) > 20 else products


def get_products_from_shop_es_all_clothes_type(user_id, shop_ids):
    user_seen_items = queries.get_entire_user_seen_items_from_db(user_id)
    res = es.search(
        index='products',
        body={
            "_source": ["shop_id", "product_id"],
            "size": 50,
            "query": {
                "bool": {
                    "filter": [
                        {
                            "terms": {
                                "shop_id": shop_ids
                            }
                        }
                    ],
                    "must_not": {
                        "terms": {
                            "product_id": user_seen_items
                        }
                    }
                }
            }
        }
    )
    products = [item['_source']['product_id'] for item in res['hits']['hits']]
    return random.sample(products, 20) if len(products) > 20 else products


def get_size_filtered_products_from_shop_es_with_clothes_type(user_id, shop_ids, clothes_type):
    user_seen_items = queries.get_clothes_type_items_shown_to_user_from_db(user_id, clothes_type)
    user_size_data = queries.get_user_size_data(user_id)
    res = es.search(
        index='products',
        body={
            "_source": ["shop_id", "product_id"],
            "size": 50,
            "query": {
                "bool": {
                    "filter": [
                        {
                            "terms": {
                                "shop_id": shop_ids
                            }
                        }
                    ],
                    "must": [
                        {
                            "term": {
                                "clothes_type": clothes_type
                            }
                        },
                        {
                            "range": {
                                "max_waist": {"gte": min(user_size_data['waist'])}
                            }
                        },
                        {
                            "range": {
                                "max_hip": {"gte": min(user_size_data['hip'])}
                            }
                        },
                        {
                            "range": {
                                "max_thigh": {"gte": min(user_size_data['thigh'])}
                            }
                        },
                        {
                            "range": {
                                "max_shoulder": {"gte": min(user_size_data['shoulder'])}
                            }
                        },
                        {
                            "range": {
                                "max_bust": {"gte": min(user_size_data['bust'])}
                            }
                        }
                    ],
                    "must_not": {
                        "terms": {
                            "product_id": user_seen_items
                        }
                    }
                }
            }
        }
    )
    products = [item['_source']['product_id'] for item in res['hits']['hits']]
    return random.sample(products, 20) if len(products) > 20 else products


def get_size_filtered_products_from_shop_es_all_clothes_type(user_id, shop_ids):
    user_seen_items = queries.get_entire_user_seen_items_from_db(user_id)
    user_size_data = queries.get_user_size_data(user_id)
    res = es.search(
        index='products',
        body={
            "_source": ["shop_id", "product_id"],
            "size": 50,
            "query": {
                "bool": {
                    "filter": [{"terms": {"shop_id": shop_ids}}],
                    "must": [
                        {
                            "range": {
                                "max_waist": {"gte": min(user_size_data['waist'])}
                            }
                        },
                        {
                            "range": {
                                "max_hip": {"gte": min(user_size_data['hip'])}
                            }
                        },
                        {
                            "range": {
                                "max_thigh": {"gte": min(user_size_data['thigh'])}
                            }
                        },
                        {
                            "range": {
                                "max_shoulder": {"gte": min(user_size_data['shoulder'])}
                            }
                        },
                        {
                            "range": {
                                "max_bust": {"gte": min(user_size_data['bust'])}
                            }
                        }
                    ],
                    "must_not": {
                        "terms": {
                            "product_id": user_seen_items
                        }
                    }
                }
            }
        }
    )
    products = [item['_source']['product_id'] for item in res['hits']['hits']]
    return random.sample(products, 20) if len(products) > 20 else products


def get_user_wearable_products(user_id):
    user_size_data = queries.get_user_size_data(user_id)
    res = es.search(
        index='products',
        body={
            "query": {
                "bool": {
                    "must": [
                        {
                            "range": {
                                "max_waist": {"gte": min(user_size_data['waist'])}
                            }
                        },
                        {
                            "range": {
                                "max_hip": {"gte": min(user_size_data['hip'])}
                            }
                        },
                        {
                            "range": {
                                "max_thigh": {"gte": min(user_size_data['thigh'])}
                            }
                        },
                        {
                            "range": {
                                "max_shoulder": {"gte": min(user_size_data['shoulder'])}
                            }
                        },
                        {
                            "range": {
                                "max_bust": {"gte": min(user_size_data['bust'])}
                            }
                        }
                    ]
                }
            }
        }
    )
    wearable_products = [item['_source']['product_id'] for item in res['hits']['hits']]
    return wearable_products


def get_user_unwearable_products(user_id):
    user_size_data = queries.get_user_size_data(user_id)
    res = es.search(
        index='products',
        body={
            "query": {
                "bool": {
                    "should": [
                        {
                            "range": {
                                "max_waist": {
                                    "lt": min(user_size_data['waist'])
                                }
                            }
                        },
                        {
                            "range": {
                                "max_hip": {
                                    "lt": min(user_size_data['hip'])
                                }
                            }
                        },
                        {
                            "range": {
                                "max_thigh": {
                                    "lt": min(user_size_data['thigh'])
                                }
                            }
                        },
                        {
                            "range": {
                                "max_shoulder": {
                                    "lt": min(user_size_data['shoulder'])
                                }
                            }
                        },
                        {
                            "range": {
                                "max_bust": {
                                    "lt": min(user_size_data['bust'])
                                }
                            }
                        }
                    ]
                }
            }
        }
    )
    unwearable_products = [item['_source']['product_id'] for item in res['hits']['hits']]
    return unwearable_products
