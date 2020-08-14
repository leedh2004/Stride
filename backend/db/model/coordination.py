import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.module.size import *


class CoordinationModel:
    def fetch_data(self, item):
        self.coor_id = item[0]
        self.user_id = item[1]
        self.coor_name = item[2]
        self.product_top_id = item[3]
        self.product_bottom_id = item[4]

