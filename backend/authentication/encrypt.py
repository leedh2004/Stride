from flask import request, g
from functools import wraps
import jwt
import sys
from datetime import datetime, timedelta
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.db.queries.user import *
from config.oauthconfig import *
import jwt


def encode_text(text):
    payload = {'text': text}
    return jwt.encode(payload, DB_ENCRYPT_KEY, algorithm='HS256').decode('utf-8')


def decode_text(text):
    payload = jwt.decode(text, DB_ENCRYPT_KEY, algorithm='HS256')
    return payload['text']

