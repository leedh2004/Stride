import sys
from decimal import Decimal
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')

class TutorialModel:
    def fetch_data(self, item, column):
        self.product_id = item[column['product_id']]
        self.thumbnail_url = item[column['thumbnail_url']]
        self.compressed_thumbnail_url = item[column['compressed_thumbnail']]
        self.image_url = item[column['image_url']]
        self.product_url = item[column['product_url']]
        self.type = item[column['type']]
        self.price = item[column['price']]
        self.product_name = item[column['product_name']]





