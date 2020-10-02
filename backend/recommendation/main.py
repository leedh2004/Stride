import backend.recommendation.queries as queries
import backend.recommendation.recommendation as recommendation

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
        return recommendation.recommend_by_shop_concepts_and_item_popularity_with_clothes_type(user_id, size_filter, clothes_category, user_seen_items)
    else:
        recommendation_list = recommendation.clothes_type_collaborative_filtering_by_likes(user_id, size_filter, clothes_category, user_seen_items)
        for cloth_type in recommendation_list:
            if len(recommendation_list[cloth_type]) < 20:
                return recommendation.recommend_by_shop_concepts_and_item_popularity_with_clothes_type(user_id, size_filter, clothes_category, user_seen_items)
        else:
            return recommendation_list


# DO NOT CALL THIS FUNCTION DIRECTLY
# returns 25 items of 'all' type
def get_all_type_item_recommendation(user_id, size_filter):
    user_seen_items = queries.get_entire_user_seen_items_from_db(user_id)
    if queries.count_user_liked_items_from_db(user_id) < 50:
        return recommendation.recommend_by_shop_concepts_and_item_popularity_all_clothes_type(user_id, size_filter, user_seen_items)
    else:
        recommendation_list = recommendation.all_type_collaborative_filtering_by_likes(user_id, size_filter, user_seen_items)
        for cloth_type in recommendation_list:
            if len(recommendation_list[cloth_type]) < 20:
                return recommendation.recommend_by_shop_concepts_and_item_popularity_all_clothes_type(user_id, size_filter, user_seen_items)
        else:
            return recommendation_list


# returns all, top, pants, skirt, dress type recommendation list
def get_entire_types_item_recommendation(user_id, size_filter):
    recommendation_list = {}
    prev_result = []
    for clothes_type in clothes_types:
        recommendation_list[clothes_type] = get_single_type_item_recommendation(user_id, clothes_type, size_filter, prev_result)[clothes_type]
        prev_result += recommendation_list[clothes_type]
    return recommendation_list


# this function should be executed periodically to update user preferrering shop concepts
def update_user_preferred_shop_concepts():
    users = queries.get_entire_user_ids_from_db()
    for user in users:
        concepts = queries.get_user_liked_shop_concepts_from_db(user)[:3]
        queries.update_user_concepts(user, concepts)