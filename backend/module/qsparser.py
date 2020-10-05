import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *

class QuerystringParser:

    @staticmethod
    def qs_parser(qs):
        for i in qs:
            if "all" == i:
                return []
        return qs


    @staticmethod
    def qs_bool(qs):
        if qs == "on":
            return True
        else:
            return False

    @staticmethod
    def int_list(qs):
        return list(map(int, qs))


    @staticmethod
    def empty_list(qs):
        if qs == ['']:
            return []
        else:
            return qs