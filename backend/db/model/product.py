import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.module.size import *


class ProductModel:
    def __init__(self):
        self.length = []
        self.waist = []
        self.hip = []
        self.thigh = []
        self.rise = []
        self.hem = []
        self.shoulder = []
        self.bust = []
        self.size = {
            'length': self.length,
            'waist': self.waist,
            'hip': self.hip,
            'thigh': self.thigh,
            'rise': self.rise,
            'hem': self.hem,
            'shoulder': self.shoulder,
            'bust': self.bust
        }

    def fetch_data(self, item):
        self.product_id = item[0]
        self.shop_id = item[1]
        self.shop_product_id = item[2]
        self.product_id = item[3]
        self.product_name = item[4]
        self.price = item[5]
        self.thumbnail_url = item[6]
        self.image_url = item[7]
        self.type = item[8]
        list_size_parse(self.length, item[9])
        list_size_parse(self.waist, item[10])
        list_size_parse(self.hip, item[11])
        list_size_parse(self.thigh, item[12])
        list_size_parse(self.rise, item[13])
        list_size_parse(self.hem, item[14])
        list_size_parse(self.shoulder, item[15])
        list_size_parse(self.bust, item[16])
        self.size_matcher()

    def size_matcher(self):
        self.size = size_matcher(self.size)
        del self.thigh, self.waist, self.length, self.bust, self.shoulder, self.hem, self.rise, self.hip

