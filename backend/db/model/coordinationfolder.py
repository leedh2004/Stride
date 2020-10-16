import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')


class CoordinationfolderModel:
    def fetch_data(self, item, column):
        self.folder_id = item[column['folder_id']]
        self.user_id = item[column['user_id']]
        self.folder_name = item[column['folder_name']]

