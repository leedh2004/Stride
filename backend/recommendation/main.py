import backend.recommendation.queries as queries
import backend.recommendation.analyze as analyze
import backend.recommendation.recommendation as recommendation
import random

es = recommendation.es

clothes_types = ('all', 'outer', 'top', 'skirt', 'pants', 'dress')


# size_category should be given as 'top', 'skirt', 'pants', 'dress' or 'all'
# if size_category is 'all', call get_all_type_item-recommendation instead
# size_filtering should be given as boolean value of True or False
def get_single_type_item_recommendation(user_id, clothes_category, size_filter, exclude_list=None):
    if clothes_category == 'all':
        return get_all_type_item_recommendation(user_id, size_filter)
    user_seen_items = queries.get_clothes_type_items_shown_to_user_from_db(user_id, clothes_category)
    if exclude_list:
        user_seen_items += exclude_list
    if queries.count_user_liked_items_from_db(user_id) < 50:
        return recommendation.recommend_by_shop_concepts_and_item_popularity_with_clothes_type(user_id, size_filter,
                                                                                               clothes_category,
                                                                                               user_seen_items)
    else:
        recommendation_list = recommendation.clothes_type_collaborative_filtering_by_likes(user_id, size_filter,
                                                                                           clothes_category,
                                                                                           user_seen_items)
        for cloth_type in recommendation_list:
            if len(recommendation_list[cloth_type]) < 20:
                return recommendation.recommend_by_shop_concepts_and_item_popularity_with_clothes_type(user_id,
                                                                                                       size_filter,
                                                                                                       clothes_category,
                                                                                                       user_seen_items)
        else:
            return recommendation_list


# DO NOT CALL THIS FUNCTION DIRECTLY
# returns 25 items of 'all' type
def get_all_type_item_recommendation(user_id, size_filter):
    user_seen_items = queries.get_entire_user_seen_items_from_db(user_id)
    if queries.count_user_liked_items_from_db(user_id) < 50:
        return recommendation.recommend_by_shop_concepts_and_item_popularity_all_clothes_type(user_id, size_filter,
                                                                                              user_seen_items)
    else:
        recommendation_list = recommendation.all_type_collaborative_filtering_by_likes(user_id, size_filter,
                                                                                       user_seen_items)
        for cloth_type in recommendation_list:
            if len(recommendation_list[cloth_type]) < 20:
                return recommendation.recommend_by_shop_concepts_and_item_popularity_all_clothes_type(user_id,
                                                                                                      size_filter,
                                                                                                      user_seen_items)
        else:
            return recommendation_list


# returns all, outer, top, pants, skirt, dress type recommendation list
def get_entire_types_item_recommendation(user_id, size_filter):
    recommendation_list = {}
    prev_result = []
    for clothes_type in clothes_types:
        recommendation_list[clothes_type] = \
        get_single_type_item_recommendation(user_id, clothes_type, size_filter, prev_result)[clothes_type]
        prev_result += recommendation_list[clothes_type]
    return recommendation_list


# this function should be executed periodically to update user preferring shop concepts
def update_user_preferred_shop_concepts():
    users = queries.get_entire_user_ids_from_db()
    for user in users:
        concepts = queries.get_user_liked_shop_concepts_from_db(user)[:3]
        queries.update_user_concepts(user, concepts)


def filter_product(user_id: str, colors: list, size_on: bool, price: list, concepts: list, clothes_type: list) -> list:
    user_prefer_concepts = queries.get_user_shop_concepts(user_id)
    user_seen_items = queries.get_entire_user_seen_items_from_db(user_id)
    filter_conditions = []
    if colors:
        terms_colors = {"terms": {"color": colors}}
        filter_conditions.append(terms_colors)
    if concepts:
        terms_shop_concept = {"terms": {"shop_concept": concepts}}
        filter_conditions.append(terms_shop_concept)
    if clothes_type and 'all' not in clothes_type:
        terms_clothes_type = {"terms": {"clothes_type": clothes_type}}
        filter_conditions.append(terms_clothes_type)
    must_conditions = []
    if price:
        range_price = {"range": {"price": {"gte": price[0], "lte": price[1]}}}
        must_conditions.append(range_price)
    if size_on:
        user_size_data = queries.get_user_size_data(user_id)
        range_size = [{"range": {"max_waist": {"gte": min(user_size_data['waist'])}}},
                      {"range": {"max_hip": {"gte": min(user_size_data['hip'])}}},
                      {"range": {"max_thigh": {"gte": min(user_size_data['thigh'])}}},
                      {"range": {"max_shoulder": {"gte": min(user_size_data['shoulder'])}}},
                      {"range": {"max_bust": {"gte": min(user_size_data['bust'])}}}]
        must_conditions += range_size
    res = es.search(
        index='products',
        body={
            "size": 50,
            "_source": ["product_id"],
            "query": {
                "bool": {
                    "filter": filter_conditions,
                    "must": must_conditions,
                    "should": {
                        "terms": {
                            "shop_concept": user_prefer_concepts
                        }
                    },
                    "must_not": [
                        {
                            "terms": {
                                "product_id": user_seen_items
                            }
                        }
                    ]
                }
            }
        }
    )
    print(res)
    result_product_ids = [item['_source']['product_id'] for item in res['hits']['hits']]
    result_product_ids = random.sample(result_product_ids, 20)
    return result_product_ids


# def concept_recommendation(user_id):
#     shop_concepts = queries.get_user_shop_concepts(user_id)
#     if 'basic' in shop_concepts:
#         shop_concepts.remove('basic')
#     recommended_items = {shop_concepts[0]: [], shop_concepts[1]: []}
