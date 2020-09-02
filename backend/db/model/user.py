import sys
from decimal import Decimal
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')


class UserSizeModel:
    def __init__(self):
        self.waist = []
        self.hip = []
        self.thigh = []
        self.shoulder = []
        self.bust = []


    def fetch_data(self, item):
        self.waist = Decimal(item[0])
        self.hip = Decimal(item[1])
        self.thigh = Decimal(item[2])
        self.shoulder = Decimal(item[3])
        self.bust = Decimal(item[4])

