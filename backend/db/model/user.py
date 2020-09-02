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
        self.waist = self.decimal_parser(item[0])
        self.hip = self.decimal_parser(item[1])
        self.thigh = self.decimal_parser(item[2])
        self.shoulder = self.decimal_parser(item[3])
        self.bust = self.decimal_parser(item[4])


    def decimal_parser(self, sizes):
        size = []
        print(sizes)
        if sizes is None:
            size = None
        else:
            for item in sizes:
                size.append(float(item))
        return size