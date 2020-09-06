# -*- coding: utf-8 -*-
from flask import Flask, g, request
from gevent.pywsgi import WSGIServer
import logging
from logbeam import CloudWatchLogsHandler
from datetime import datetime
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.api_v1.dressroom import dressroom
from backend.api_v1.coordination import coordination
from backend.api_v1.login import login
from backend.api_v1.home import home
from backend.api_v1.user import user
from backend.api_v1.auth import auth
from backend.authentication.kakao import kakao
from backend.authentication.naver import naver
from backend.authentication.auth import *
from flask_cors import CORS

## MOBILE VERSION
app_version = '0.1.0'

dt = datetime.now()
log_name = str(dt.year) +'-'+ str(dt.month) +'-'+ str(dt.day)
LOG_FORMAT = "[%(asctime)-10s] - %(message)s"
logging.basicConfig(level=logging.INFO, format=LOG_FORMAT)

app = Flask(__name__)
app.url_map.strict_slashes = False

CORS(app, resources={r'*': {'origins': '*'}})

app.register_blueprint(dressroom, url_prefix='/dressroom')
app.register_blueprint(coordination, url_prefix='/coordination')
app.register_blueprint(login, url_prefix='/login')
app.register_blueprint(kakao, url_prefix='/kakao')
app.register_blueprint(home, url_prefix='/home')
app.register_blueprint(naver, url_prefix='/naver')
app.register_blueprint(user, url_prefix='/user')
app.register_blueprint(auth, url_prefix='/auth')

cw_handler = CloudWatchLogsHandler(
    log_group_name='stride',
    log_stream_name=log_name,
    buffer_duration=10000,
    batch_count=10,
    batch_size=1048576
)
dev_cw_handler = CloudWatchLogsHandler(
    log_group_name='stride',
    log_stream_name=log_name,
    buffer_duration=10000,
    batch_count=10,
    batch_size=1048576
)
except_url = ['/', '/login/token', '/kakao/oauth', '/naver/oauth', '/auth/token']

@app.route('/')
def hello_world():
    return 'Hello World! CI TEST7 only develop'


@app.after_request
def log(response):
    user = ''
    access_token = None
    headers = request.headers.get("Authorization")
    if headers is not None:
        access_token = headers.split(' ')[1]
    if access_token is not None:
        try:
            payload = decode_jwt_token(access_token)
            user = payload['user_id']
        except jwt.InvalidTokenError:
            user = 'unidentified'
    else:
        user = 'unidentified'
    if 'http://0.0.0.0:5000' in request.base_url: # dev
        logger = logging.getLogger(log_name)
        logger.addHandler(dev_cw_handler)
    else:
        logger = logging.getLogger(log_name)
        logger.addHandler(cw_handler)
    if request.method in ['GET', 'DELETE']:
        log_msg = "{0}-{1}-{2}-{3}".format(str(user), str(request), str(response.status), str(response.get_data()))
    else:
        log_msg = "{0}-{1}-{2}-{3}-{4}".format(str(user), str(request), str(response.status), str(response.get_data()), str(request.get_data()))
    logger.info(log_msg)
    return response


if __name__ == '__main__':
    # Development
    # app.run(host='0.0.0.0', port=5000)

    # Production
    print("Server on 5000 Port")
    http_server = WSGIServer(('', 5000), app)
    http_server.serve_forever()
