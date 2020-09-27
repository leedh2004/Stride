from math import *

class DBMapping:

    @staticmethod
    def mapping_column(cursor):
        colname = [desc[0] for desc in cursor.description]
        colname = {string: i for i, string in enumerate(colname)}
        return colname

