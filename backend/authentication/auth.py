from flask import request, g
from functools import wraps
import jwt
import sys
from datetime import datetime, timedelta
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.db.queries.user import *


def encode_jwt_token(id):
    token = jwt.encode({'user_id': id, 'exp': datetime.utcnow() + timedelta(days=14)},
                       ENCRIPTION_SECRET, algorithm='HS256').decode('utf-8')
    return token


def decode_jwt_token(token):
    token = jwt.decode(token, ENCRIPTION_SECRET, algorithm='HS256')
    return token


def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        headers = request.headers.get("Authorization")
        access_token = headers.split(' ')[1]
        if access_token is not None:
            try:
                payload = decode_jwt_token(access_token)
            except jwt.InvalidTokenError:
                payload = None
            if payload is None:
                return '', 401
            user_id = payload["user_id"]
            exp = payload["exp"]
            time = datetime.utcnow()
            exp = datetime.fromtimestamp(exp)
            compare = exp - time
            if int(compare.days) < 0:
                return '', 401
            g.user_id = user_id
            # g.user = get_user_info(user_id) if user_id else None
        else:
            return '', 401
        return f(*args, **kwargs)
    return decorated_function