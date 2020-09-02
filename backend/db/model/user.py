import sys
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
        self.waist = item[0]
        self.hip = item[1]
        self.thigh = item[2]
        self.shoulder = item[3]
        self.bust = item[4]

