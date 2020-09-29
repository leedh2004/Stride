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

    def fetch_data(self, item, column):
        self.product_id = item[column['product_id']]
        self.likes = item[column['likes']]
        self.likes_time = str(item[column['created_at']]).split(" ")[0]
        self.product_url = item[column['product_url']]
        self.product_name = item[column['product_name']]
        self.price = item[column['price']]
        self.thumbnail_url = item[column['thumbnail_url']]
        self.image_url = item[column['image_url']]
        self.type = item[column['type']]
        self.shop_name = item[column['shop_kor']]
        SizeParser.list_size_parse(self.length, item[column['length']])
        SizeParser.list_size_parse(self.waist, item[column['waist']])
        SizeParser.list_size_parse(self.hip, item[column['hip']])
        SizeParser.list_size_parse(self.thigh, item[column['thigh']])
        SizeParser.list_size_parse(self.rise, item[column['rise']])
        SizeParser.list_size_parse(self.hem, item[column['hem']])
        SizeParser.list_size_parse(self.shoulder, item[column['shoulder']])
        SizeParser.list_size_parse(self.bust, item[column['bust']])
        self.size_matcher()
        self.limit_images(4)

    def fetch_brief_data(self, item, column):
        self.product_id = item[column['product_id']]
        self.likes = item[column['likes']]

    def get_brief_data(self):
        brief_data = {
            'product_id': self.product_id,
            'likes': self.likes
        }
        return brief_data


    def size_matcher(self):
        self.size = SizeParser.size_matcher(self.size)
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
