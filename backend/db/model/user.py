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
        self.waist = self.decimal_parser(item[0], 'waist')
        self.hip = self.decimal_parser(item[1], 'hip')
        self.thigh = self.decimal_parser(item[2], 'thigh')
        self.shoulder = self.decimal_parser(item[3], 'shoulder')
        self.bust = self.decimal_parser(item[4], 'bust')


    def decimal_parser(self, sizes, tag):
        size = []
        if sizes is None:
            size = None
        else:
            for item in sizes:
                if tag == 'hip' or tag == 'bust':
                    size.append(float(item) / 2)
                elif tag == 'waist':
                    size.append(float(item) * 1.27)
                else:
                    size.append(float(item))
        return size

