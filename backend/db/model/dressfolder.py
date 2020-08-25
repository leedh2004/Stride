import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')


class DressfolderModel:
    def fetch_data(self, item):
        self.folder_id = item[0]
        self.user_id = item[1]
        self.folder_name = item[2]

