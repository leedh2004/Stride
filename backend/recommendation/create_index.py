import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
es = es_connection

user_ratings_mapping = \
    {
        "settings": {
            "number_of_shards": 1,
            "number_of_replicas": 1
        },
        "mappings": {
            "properties": {
                "user_id": {"type": "keyword"},
                "shop_id": {"type": "keyword"},
                "product_id": {"type": "keyword"},
                "clothes_type": {"type": "keyword"},
                "shop_concept": {"type": "keyword"},
                "rating": {"type": "keyword"}  # like, dislike
            }
        }
    }

products_mapping = \
    {
        "settings": {
            "number_of_shards": 1,
            "number_of_replicas": 1
        },
        "mappings": {
            "properties": {
                "product_id": {"type": "keyword"},
                "shop_id": {"type": "keyword"},
                "shop_concept": {"type": "keyword"},
                "color": {"type": "keyword"},
                "clothes_type": {"type": "keyword"},
                "price": {"type": "integer"},
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
        }
    }

user_like_items_mapping = \
    {
        "settings": {
            "number_of_shards": 1,
            "number_of_replicas": 1
        },
        "mappings": {
            "properties": {
                "user_id": {"type": "keyword"},
                "user_preferred_concepts": {"type": "keyword"},  # chic, street, daily...
                "product_id": {"type": "keyword"},  # list of products
                "clothes_type": {"type": "keyword"}  # outer, top, dress, skirt, pants
            }
        }
    }





# create index
if not es.indices.exists(index="user_ratings"):
    es.indices.create(index="user_ratings", body=user_ratings_mapping)
if not es.indices.exists(index='user_like_items'):
    es.indices.create(index='user_like_items', body=user_like_items_mapping)
if not es.indices.exists(index='products'):
    es.indices.create(index='products', body=products_mapping)