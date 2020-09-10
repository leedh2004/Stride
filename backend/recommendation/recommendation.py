import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
import backend.recommendation.analyze as analyze
import random
from config.oauthconfig import *
import backend.recommendation.queries as queries
import time

es = es_connection

clothes_types = ('top', 'dress', 'skirt', 'pants')


def append_if_not_exists(recommendation_list, items):
    for item in items:
        if item not in recommendation_list:
            recommendation_list.append(item)


def recommend_by_shop_concepts_and_item_popularity_with_clothes_type(user_id, size_filtering, clothes_type):
    user_preferred_shops = queries.get_recommended_shops_by_user_preferred_concepts_from_db(user_id)
    recommendation_list = {}
    # get items from preferred shops
    if size_filtering:
        recommendation_list[clothes_type] = \
            analyze.get_size_filtered_products_from_shop_es_with_clothes_type(user_id, user_preferred_shops, clothes_type)
    else:
        recommendation_list[clothes_type] = analyze.get_products_from_shop_es_with_clothes_type(user_id, user_preferred_shops, clothes_type)
    # insert popular items
    popular_items = queries.get_clothes_type_popular_items_from_db(clothes_type)
    append_if_not_exists(recommendation_list[clothes_type], popular_items)
    # insert non-preferred items
    non_preferred_items = queries.get_clothes_type_non_preferred_items_from_db(user_preferred_shops, clothes_type)
    append_if_not_exists(recommendation_list[clothes_type], non_preferred_items)
    return recommendation_list


def recommend_by_shop_concepts_and_item_popularity_all_clothes_type(user_id, size_filtering):
    user_preferred_shops = queries.get_recommended_shops_by_user_preferred_concepts_from_db(user_id)
    recommendation_list = {}
    # get items from preferred shops
    if size_filtering:
        recommendation_list['all'] = \
            analyze.get_size_filtered_products_from_shop_es_all_clothes_type(user_id, user_preferred_shops)
    else:
        recommendation_list['all'] = analyze.get_products_from_shop_es_all_clothes_type(user_id, user_preferred_shops)
    # insert popular items
    popular_items = queries.get_all_type_popular_items_from_db()
    append_if_not_exists(recommendation_list['all'], popular_items)
    # insert non-preferred items
    non_preferred_items = queries.get_all_type_non_preferred_items_from_db(user_preferred_shops)
    append_if_not_exists(recommendation_list['all'], non_preferred_items)
    return recommendation_list


def clothes_type_collaborative_filtering_by_likes(user_id, size_filtering, clothes_type):
    recommendation_list = {}
    user_liked_items = analyze.get_user_liked_items_from_cf_index(user_id)
    user_seen_list = queries.get_entire_user_seen_items_from_db(user_id)
    user_excluded_list = user_seen_list + analyze.get_user_unwearable_products(user_id) \
        if size_filtering else user_seen_list
    res = es.search(
        index="user_rated_items",
        body={
            "query": {
                "bool": {
                    "filter": [{"term": {"clothes_type": clothes_type}}, {"term": {"rating": "like"}}],
                    "should": [{"term": {"product_id": product}} for product in user_liked_items],
                    "minimum_should_match": 2
                }
            },
            "aggs": {
                "cf_recommendation": {
                    "significant_terms": {
                        "field": "product_id",
                        "exclude": user_excluded_list,
                        "min_doc_count": 2,
                        "size": 30
                    }
                }
            }
        }
    )
    res = res['aggregations']['cf_recommendation']['buckets']
    recommendation_list[clothes_type] = [result_item['key'] for result_item in res]
    # insert non_preferred_items if collaborative filtering is available
    if recommendation_list[clothes_type]:
        non_preferred_items = queries.get_clothes_type_non_preferred_items_from_db(queries.get_recommended_shops_by_user_preferred_concepts_from_db(user_id), clothes_type)
        append_if_not_exists(recommendation_list[clothes_type], non_preferred_items)
    return recommendation_list


def all_type_collaborative_filtering_by_likes(user_id, size_filtering):
    recommendation_list = {}
    user_liked_items = analyze.get_user_liked_items_from_cf_index(user_id)
    user_seen_list = queries.get_entire_user_seen_items_from_db(user_id)
    user_excluded_list = user_seen_list + analyze.get_user_unwearable_products(user_id) \
        if size_filtering else user_seen_list
    res = es.search(
        index="user_rated_items",
        body={
            "query": {
                "bool": {
                    "filter": [{"term": {"rating": "like"}}],
                    "should": [{"term": {"product_id": product}} for product in user_liked_items],
                    "minimum_should_match": 2
                }
            },
            "aggs": {
                "cf_recommendation": {
                    "significant_terms": {
                        "field": "product_id",
                        "exclude": user_excluded_list,
                        "min_doc_count": 2,
                        "size": 30
                    }
                }
            }
        }
    )
    res = res['aggregations']['cf_recommendation']['buckets']
    recommendation_list['all'] = [result_item['key'] for result_item in res]
    # insert non_preferred_items if collaborative filtering is available
    if recommendation_list['all']:
        non_preferred_items = queries.get_all_type_non_preferred_items_from_db(
            queries.get_recommended_shops_by_user_preferred_concepts_from_db(user_id), )
        append_if_not_exists(recommendation_list['all'], non_preferred_items)
    return recommendation_list



# print(recommend_items_from_tutorial_shop_preference('1445382661@kakao'))

# replaced as using only db data
# def recommended_shops_by_user_preferred_concepts_from_es(user_id, tutorial_flag=False, tutorial_shop_concepts=None):
#     if tutorial_flag:
#         user_preferred_concepts = tutorial_shop_concepts
#     else:
#         user_preferred_concepts = queries.get_user_liked_shop_concepts_from_db(user_id)
#     # print('user_preferred_concepts:', user_preferred_concepts)
#     res = es.search(
#         index="user_ratings",
#         body={
#             "_source": ["shop_id", "product_id"],
#             "query": {
#                 "bool": {
#                     "must": [
#                         {
#                             "match": {
#                                 "shop_concept": user_preferred_concepts[0]
#                             }
#                         }
#                     ],
#                     "should": [
#                         {
#                             "match": {
#                                 "shop_concept": concept
#                             }
#                         } for concept in user_preferred_concepts[1:]
#                     ]
#                 }
#             },
#             "aggs": {
#                 "shop_ids": {
#                     "terms": {
#                         "field": "shop_id",
#                         "order": {
#                             "rel_score": "desc"
#                         }
#                     },
#                     "aggs": {
#                         "rel_score": {
#                             "max": {
#                                 "script": "_score"
#                             }
#                         }
#                     }
#                 }
#             }
#         }
#     )
#     res = res['aggregations']['shop_ids']['buckets']
#     # extract top 5 shops
#     return [result_item['key'] for result_item in res]
