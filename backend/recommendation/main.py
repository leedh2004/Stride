import backend.recommendation.index as index
import backend.recommendation.queries as queries
import time
import backend.recommendation.recommendation as recommendation

es = index.es


# size_category should be given as 'top', 'skirt', 'pants', 'dress' or 'all'
# if size_category is 'all', call get_all_type_item-recommendation instead
# size_filtering should be given as boolean value of True or False
def get_item_recommendation(user_id, size_category, size_filter):
    if size_category == 'all':
        return get_all_type_item_recommendation(user_id, size_filter)
    if queries.count_user_liked_items_from_db(user_id) < 100:
        return recommendation.recommend_by_shop_concepts_and_item_popularity_with_clothes_type(user_id, size_filter, size_category)
    else:
        recommendation_list = recommendation.clothes_type_collaborative_filtering_by_likes(user_id, size_filter, size_category)
        for cloth_type in recommendation_list:
            if len(recommendation_list[cloth_type]) < 20:
                return recommendation.recommend_by_shop_concepts_and_item_popularity_with_clothes_type(user_id, size_filter, size_category)
        else:
            return recommendation_list


def get_all_type_item_recommendation(user_id, size_filter):
    if queries.count_user_liked_items_from_db(user_id) < 100:
        return recommendation.recommend_by_shop_concepts_and_item_popularity_all_clothes_type(user_id, size_filter)
    else:
        recommendation_list = recommendation.all_type_collaborative_filtering_by_likes(user_id, size_filter)
        for cloth_type in recommendation_list:
            if len(recommendation_list[cloth_type]) < 20:
                return recommendation.recommend_by_shop_concepts_and_item_popularity_all_clothes_type(user_id, size_filter)
        else:
            return recommendation_list


def index_recommendation_result(user_id, recommendation_list, size_filtering):
    index_name = 'recommendation_list_size_filtered' if size_filtering else 'recommendation_list'
    for clothes_type in recommendation_list:
        doc = {'user_id': user_id, 'recommended_products': recommendation_list[clothes_type],
               'clothes_type': clothes_type}
        print('indexing:', doc)
        es.index(index=index_name, body=doc, id=doc['user_id'] + doc['clothes_type'])