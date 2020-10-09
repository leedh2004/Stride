import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
import backend.recommendation.main as main
import backend.recommendation.index as index

es = main.es

# update user preferred shop concepts to db
main.update_user_preferred_shop_concepts()

# index product data to ES
index.index_product_documents()

# index user rating data to ES
index.index_user_rating_data()
