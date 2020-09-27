import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.module.size import *


class CoordinationModel:
    def fetch_data(self, item, column):
        self.coor_id = item[column['coor_id']]
        self.user_id = item[column['user_id']]
        self.coor_name = item[column['coor_name']]
        self.product_top_id = item[column['product_top_id']]
        self.product_bottom_id = item[column['product_bottom_id']]

