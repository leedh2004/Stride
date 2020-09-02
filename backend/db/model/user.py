import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')


class UserSizeModel:
    def __init__(self):
        self.waist = []
        self.hip = []
        self.thigh = []
        self.hem = []
        self.shoulder = []
        self.bust = []
        self.size = {
            'waist': self.waist,
            'hip': self.hip,
            'thigh': self.thigh,
            'hem': self.hem,
            'shoulder': self.shoulder,
            'bust': self.bust
        }

    def fetch_data(self, item):
        self.waist = item[0]
        self.hip = item[1]
        self.thigh = item[2]
        self.hem = item[3]
        self.shoulder = item[4]
        self.bust = item[5]

