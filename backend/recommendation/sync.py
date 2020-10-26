import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
import backend.recommendation.main as main
import backend.recommendation.index as index
from backend.db.init import *

with es_connect() as es_connection:
    # update user preferred shop concepts to db
    main.update_user_preferred_shop_concepts()

    # index product data to ES
    index.index_product_documents(es_connection)

    # index user rating data to ES
    index.index_user_rating_data(es_connection)

    # remove invalid items
    index.remove_invalid_items(es_connection)


