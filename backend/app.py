# -*- coding: utf-8 -*-
from flask import Flask, g, request
from gevent.pywsgi import WSGIServer
import logging
import logging.config
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
from backend.api_v1.tutorial import tutorial
from backend.api_v2.home import v2_home
from backend.api_v2.recommenation import v2_recommendation
from backend.api_v2.coordination import v2_coordination
from backend.api_v2.dressroom import v2_dressroom
from backend.authentication.kakao import kakao
from backend.authentication.naver import naver
from backend.authentication.auth import *
from flask_cors import CORS

dt = datetime.now()


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
app.register_blueprint(tutorial, url_prefix='/tutorial')

app.register_blueprint(v2_home, url_prefix='/v2/home')
app.register_blueprint(v2_recommendation, url_prefix='/v2/recommendation')
app.register_blueprint(v2_coordination, url_prefix='/v2/coordination')
app.register_blueprint(v2_dressroom, url_prefix='/v2/dressroom')

with open("logging.json", "rt") as file:
    config = json.load(file)
logging.config.dictConfig(config)
logger = logging.getLogger()


@app.route('/admin/check')
def hello_world():
    return 'Server ON', 200

@app.route('/error')
def error_test():
    return 'error', 500

@app.after_request
def log(response):
    try:
        auth = authentication()
        # health check
        if request.path == '/admin/check':
            return response
        if auth is False:
            user = 'unidentified'
        else:
            user = g.user_id
        if request.method in ['GET', 'DELETE']:
            log_msg = "{0}-{1}-{2}-{3}-{4}".format(str(dt.now()), str(user), str(response.status), str(request),  str(response.data))
        else:
            log_msg = "{0}-{1}-{2}-{3}-{4}-{5}".format(str(dt.now()), str(user), str(response.status), str(request), str(response.data), str(request.data))
        logger.info(log_msg)
        return response
    except Exception as Ex:
        log_msg = "{0}-{1}-{2}-{3}".format(str(dt.now()), str(Ex), str(request), str(response.data))
        logger.info(log_msg)
        return response

if __name__ == '__main__':
    print("Server on 5000 Port, MODE = PRODUCTION")
    http_server = WSGIServer(('', 5000), app)
    http_server.serve_forever()
