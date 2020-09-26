import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.module.size import *
from datetime import datetime

class EvaluationModel:
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
        self.product_id = item[1]
        self.likes = item[2]
        self.likes_time = str(item[3]).split(" ")[0]
        self.product_url = item[9]
        self.product_name = item[10]
        self.price = item[11]
        self.thumbnail_url = item[12]
        self.image_url = item[13]
        self.type = item[14]
        self.shop_name = item[34]
        list_size_parse(self.length, item[15])
        list_size_parse(self.waist, item[16])
        list_size_parse(self.hip, item[17])
        list_size_parse(self.thigh, item[18])
        list_size_parse(self.rise, item[19])
        list_size_parse(self.hem, item[20])
        list_size_parse(self.shoulder, item[21])
        list_size_parse(self.bust, item[22])
        self.size_matcher()
        self.limit_images(4)

    def size_matcher(self):
        self.size = size_matcher(self.size)
        del self.thigh, self.waist, self.length, self.bust, self.shoulder, self.hem, self.rise, self.hip


    def limit_images(self, limit_args):
        result = []
        cnt = 0
        for image in self.image_url:
            cnt = cnt + 1
            result.append(image)
            if cnt > limit_args:
                break
        self.image_url = result
