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

mode = ''
dt = datetime.now()

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
log_stream = 'api-log.'



@app.route('/admin/check')
def hello_world():
    return 'Server ON', 200


@app.after_request
def log(response):
    user = ''
    if authentication() is False:
        user = 'unidetified'
    if mode == 'dev':
        logger = logging.getLogger(log_stream)
        logger.addHandler(dev_cw_handler)

    elif 'prod' in mode:
        logger = logging.getLogger(log_stream + mode)
        logger.addHandler(cw_handler)

    if request.method in ['GET', 'DELETE']:
        log_msg = "{0}-{1}-{2}-{3}".format(str(user), str(request), str(response.status), str(response.get_data()))
    else:
        log_msg = "{0}-{1}-{2}-{3}-{4}".format(str(user), str(request), str(response.status), str(response.get_data()), str(request.get_data()))
    logger.info(log_msg)
    return response


if __name__ == '__main__':
    mode = sys.argv[1]
    cw_handler = CloudWatchLogsHandler(
        log_group_name='stride',
        log_stream_name=log_stream + mode,
        buffer_duration=10000,
        batch_count=10,
        batch_size=1048576
    )
    dev_cw_handler = CloudWatchLogsHandler(
        log_group_name='dev_stride',
        log_stream_name=log_stream,
        buffer_duration=10000,
        batch_count=10,
        batch_size=1048576
    )
    print("Server on 5000 Port, MODE =", mode)
    if mode == 'dev':
        app.run(host='0.0.0.0', port=5000)
    elif 'prod' in mode:
        http_server = WSGIServer(('', 5000), app)
        http_server.serve_forever()
    else:
        print("Mode Only [dev, prod]")

