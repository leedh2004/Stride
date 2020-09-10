import backend.recommendation.index as index
import backend.recommendation.queries as queries
import backend.recommendation.analyze as analyze
import time
import backend.recommendation.recommendation as recommendation

es = index.es
clothes_types = recommendation.clothes_types  # top, dress, skirt, pants


def make_all_out_of_list(recommendation_list):
    recommendation_list['all'] = []
    for cloth_type in ('top', 'dress', 'skirt', 'pants'):
        recommendation_list['all'] += recommendation_list[cloth_type][:5]
        recommendation_list[cloth_type] = recommendation_list[cloth_type][5:]
    return recommendation_list


def get_item_recommendation(user_id, size_category, size_filter):
    if queries.count_user_liked_items_from_db(user_id) < 100:
        recommendation_list = recommendation.recommend_by_shop_concepts_and_item_popularity(user_id, size_filter, size_category)
    else:
        recommendation_list = recommendation.collaborative_filtering_by_likes(user_id, size_filter, size_category)
        for cloth_type in recommendation_list:
            if not recommendation_list[cloth_type] or len(recommendation_list[cloth_type]) < 20:
                recommendation_list = recommendation.recommend_by_shop_concepts_and_item_popularity(user_id, size_filter, size_category)
                break
    return make_all_out_of_list(recommendation_list) if size_category == 'all' else recommendation_list


# size_category should be given as 'top', 'skirt', 'pants', 'dress' or 'all'
def update_recommendation_list(user_id, size_category):
    size_filtered_recommendation_result = get_item_recommendation(user_id, size_category, size_filter=True)
    # non_filtered_recommendation_result = get_item_recommendation(user_id, size_category, size_filter=False)
    return size_filtered_recommendation_result#non_filtered_recommendation_result
    # for clothes_type in size_filtered_recommendation_result:
    #     doc = {'user_id': user_id, 'recommended_products': size_filtered_recommendation_result[clothes_type],
    #            'clothes_type': clothes_type}
    #     print('indexing[filter_on]:', doc)
    #     es.index(index='recommendation_list_size_filtered', body=doc, id=doc['user_id'] + doc['clothes_type'])
    # for clothes_type in non_filtered_recommendation_result:
    #     doc = {'user_id': user_id, 'recommended_products': non_filtered_recommendation_result[clothes_type],
    #            'clothes_type': clothes_type}
    #     print('indexing[filter_off]:', doc)
    #     es.index(index='recommendation_list', body=doc, id=doc['user_id'] + doc['clothes_type'])
