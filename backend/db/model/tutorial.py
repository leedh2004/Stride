import sys
from decimal import Decimal
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')

class TutorialModel:
    def fetch_data(self, item, colname):
        self.product_id = item[colname['product_id']]
        self.thumbnail_url = item[colname['thumbnail_url']]




