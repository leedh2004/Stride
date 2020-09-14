import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
import backend.recommendation.analyze as analyze
from config.oauthconfig import *
import backend.recommendation.queries as queries
import random

es = es_connection


def append_if_not_exists(recommendation_list, items):
    for item in items:
        if item not in recommendation_list:
            recommendation_list.append(item)


def recommend_by_shop_concepts_and_item_popularity_with_clothes_type(user_id, size_filtering, clothes_type, user_seen_items):
    user_preferred_shops = queries.get_recommended_shops_by_user_preferred_concepts_from_db(user_id)
    recommendation_list = {}
    # get items from preferred shops
    if size_filtering:
        recommendation_list[clothes_type] = \
            analyze.get_size_filtered_products_from_shop_es_with_clothes_type(user_id, user_preferred_shops, clothes_type, user_seen_items)
    else:
        recommendation_list[clothes_type] = analyze.get_products_from_shop_es_with_clothes_type(user_preferred_shops, clothes_type, user_seen_items)
    # insert popular items
    popular_items = analyze.get_clothes_type_popular_items(clothes_type, user_seen_items)
    append_if_not_exists(recommendation_list[clothes_type], popular_items)
    # shuffle the list so far
    random.shuffle(recommendation_list[clothes_type])
    # append non-preferred items
    non_preferred_items = queries.get_clothes_type_non_preferred_items_from_db(user_preferred_shops, clothes_type)
    append_if_not_exists(recommendation_list[clothes_type], non_preferred_items)
    return recommendation_list


def recommend_by_shop_concepts_and_item_popularity_all_clothes_type(user_id, size_filtering, user_seen_items):
    user_preferred_shops = queries.get_recommended_shops_by_user_preferred_concepts_from_db(user_id)
    recommendation_list = {}
    # get items from preferred shops
    if size_filtering:
        recommendation_list['all'] = \
            analyze.get_size_filtered_products_from_shop_es_all_clothes_type(user_id, user_preferred_shops, user_seen_items)
    else:
        recommendation_list['all'] = analyze.get_products_from_shop_es_all_clothes_type(user_preferred_shops, user_seen_items)
    # insert popular items
    popular_items = analyze.get_all_type_popular_items(user_seen_items)
    append_if_not_exists(recommendation_list['all'], popular_items)
    # shuffle the list so far
    random.shuffle(recommendation_list['all'])
    # append non-preferred items
    non_preferred_items = queries.get_all_type_non_preferred_items_from_db(user_preferred_shops)
    append_if_not_exists(recommendation_list['all'], non_preferred_items)
    return recommendation_list


def clothes_type_collaborative_filtering_by_likes(user_id, size_filtering, clothes_type, user_seen_list):
    recommendation_list = {}
    user_preferred_shops = queries.get_recommended_shops_by_user_preferred_concepts_from_db(user_id)
    user_liked_items = analyze.get_user_liked_items_from_cf_index(user_id)
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
        non_preferred_items = analyze.get_clothes_type_non_preferred_items_from_es(user_preferred_shops, clothes_type, user_excluded_list)
        append_if_not_exists(recommendation_list[clothes_type], non_preferred_items)
    return recommendation_list


def all_type_collaborative_filtering_by_likes(user_id, size_filtering, user_seen_list):
    recommendation_list = {}
    user_preferred_shops = queries.get_recommended_shops_by_user_preferred_concepts_from_db(user_id)
    user_liked_items = analyze.get_user_liked_items_from_cf_index(user_id)
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
        non_preferred_items = analyze.get_clothes_type_non_preferred_items_from_es(user_preferred_shops, user_excluded_list)
        append_if_not_exists(recommendation_list['all'], non_preferred_items)
    return recommendation_list
