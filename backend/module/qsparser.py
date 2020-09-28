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
                return 'all'
        return qs

