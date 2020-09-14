import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
es = es_connection

user_ratings_mapping = \
    {
        "settings": {
            "number_of_shards": 2,
            "number_of_replicas": 1
        },
        "mappings": {
            "properties": {
                "user_id": {"type": "keyword"},
                "shop_id": {"type": "keyword"},
                "product_id": {"type": "keyword"},
                "clothes_type": {"type": "keyword"},
                "shop_concept": {"type": "keyword"},
                "rating": {"type": "keyword"},  # like, pass, dislike
                "preference_score": {"type": "float"}
            }
        }
    }

products_mapping = \
    {
        "settings": {
            "number_of_shards": 2,
            "number_of_replicas": 1
        },
        "shop_id": {"type": "keyword"},
        "product_id": {"type": "keyword"},
        "clothes_type": {"type": "keyword"},
        "max_length": {"type": "float"},
        "min_length": {"type": "float"},
        "max_waist": {"type": "float"},
        "min_waist": {"type": "float"},
        "max_hip": {"type": "float"},
        "min_hip": {"type": "float"},
        "max_thigh": {"type": "float"},
        "min_thigh": {"type": "float"},
        "max_rise": {"type": "float"},
        "min_rise": {"type": "float"},
        "max_hem": {"type": "float"},
        "min_hem": {"type": "float"},
        "max_shoulder": {"type": "float"},
        "min_shoulder": {"type": "float"},
        "max_bust": {"type": "float"},
        "min_bust": {"type": "float"},
        "max_arm_length": {"type": "float"},
        "min_arm_length": {"type": "float"}
    }

user_rated_items_mapping = \
    {
        "settings": {
            "number_of_shards": 2,
            "number_of_replicas": 1
        },
        "mappings": {
            "properties": {
                "user_id": {"type": "keyword"},
                "rating": {"type": "keyword"},  # like, pass, dislike
                "product_id": {"type": "keyword"},  # list of products
                "clothes_type": {"type": "keyword"}  # top, dress, skirt, pants
            }
        }
    }


recommendation_list_mapping = \
    {
        "settings": {
            "number_of_shards": 2,
            "number_of_replicas": 1
        },
        "mappings": {
            "properties": {
                "user_id": {"type": "keyword"},
                "recommended_products": {"type": "keyword"},
                "clothes_type": {"type": "keyword"},
            }
        }
    }

recommendation_list_size_filtered_mapping = \
    {
        "settings": {
            "number_of_shards": 2,
            "number_of_replicas": 1
        },
        "mappings": {
            "properties": {
                "user_id": {"type": "keyword"},
                "recommended_products": {"type": "keyword"},
                "clothes_type": {"type": "keyword"},
            }
        }
    }


recommendation_history_mapping = \
    {
        "settings": {
            "number_of_shards": 2,
            "number_of_replicas": 1
        },
        "mappings": {
            "properties": {
                "user_id": {"type": "keyword"},
                "recommended_products": {"type": "keyword"},
                "clothes_type": {"type": "keyword"}
            }
        }
    }


# create index
if not es.indices.exists(index="user_ratings"):
    es.indices.create(index="user_ratings", body=user_ratings_mapping)
if not es.indices.exists(index='user_rated_items'):
    es.indices.create(index='user_rated_items', body=user_rated_items_mapping)
if not es.indices.exists(index='recommendation_list'):
    es.indices.create(index='recommendation_list', body=recommendation_list_mapping)
if not es.indices.exists(index='recommendation_list_size_filtered'):
    es.indices.create(index='recommendation_list_size_filtered', body=recommendation_list_size_filtered_mapping)
if not es.indices.exists(index='recommendation_history'):
    es.indices.create(index='recommendation_history', body=recommendation_history_mapping)