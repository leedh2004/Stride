import sys
from decimal import Decimal
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')

class TutorialModel:
    def __init__(self, colname):
        self.colname = {string : i for i,string in enumerate(colname)}

    def fetch_data(self, item):
        self.product_id = item[self.colname['product_id']]
        self.thumbnail_url = item[self.colname['thumbnail_url']]




