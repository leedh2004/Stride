import sys
from decimal import Decimal
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.module.size import SizeParser
from math import *

class UserSizeModel:
    def __init__(self):
        self.waist = []
        self.hip = []
        self.thigh = []
        self.shoulder = []
        self.bust = []

    def origin_fetch_data(self, item, column):
        self.waist = SizeParser.decimal_parser(item[column['waist']], 'waist')
        self.hip = SizeParser.decimal_parser(item[column['hip']], 'hip')
        self.thigh = SizeParser.decimal_parser(item[column['thigh']], 'thigh')
        self.shoulder = SizeParser.decimal_parser(item[column['shoulder']], 'shoulder')
        self.bust = SizeParser.decimal_parser(item[column['bust']], 'bust')





