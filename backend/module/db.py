import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
import jwt

class DBMapping:
    @staticmethod
    def mapping_column(cursor):
        colname = [desc[0] for desc in cursor.description]
        colname = {string: i for i, string in enumerate(colname)}
        return colname


class DBEncryption:
    @staticmethod
    def encode_text(text):
        payload = {'text': text}
        return jwt.encode(payload, DB_ENCRYPT_KEY, algorithm='HS256').decode('utf-8')

    @staticmethod
    def decode_text(text):
        payload = jwt.decode(text, DB_ENCRYPT_KEY, algorithm='HS256')
        return payload['text']