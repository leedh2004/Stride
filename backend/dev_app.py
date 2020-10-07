# -*- coding: utf-8 -*-
from flask import Flask, g, request
from gevent.pywsgi import WSGIServer
# import logging
# from logbeam import CloudWatchLogsHandler
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

# LOG_FORMAT = "[%(asctime)-10s] - %(message)s"
# logging.basicConfig(level=logging.INFO, format=LOG_FORMAT)

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
# log_stream = 'api-log'
#
# dev_cw_handler = CloudWatchLogsHandler(
#         log_group_name='dev_stride',
#         log_stream_name=log_stream,
#         buffer_duration=10000,
#         batch_count=10,
#         batch_size=1048576)

# def log_parse(path, qs, res_data):
#     res_all = {
#         'top': [],
#         'all': [],
#         'skirt': [],
#         'dress': [],
#         'pants': []
#     }
#     res = {
#         'total': 0,
#         'product_id': []
#     }
#     try:
#         if path == '/home/all':
#             res_json = json.loads(res_data)
#             for key in res_json.keys():
#                 for item in res_json[key]:
#                     res_all[key].append(item['product_id'])
#             return res_all
#         elif 'size' in str(qs):
#             res_json = json.loads(res_data)
#             for data in res_json:
#                 res['product_id'].append(data['product_id'])
#             res['total'] = len(res['product_id'])
#             return res
#         else:
#             return False
#     except:
#         return False


@app.route('/admin/check')
def hello_world():
    return 'Server ON', 200

@app.route('/error')
def error_test():
    return 'error', 500

@app.after_request
def log(response):
    auth = authentication()
    # health check
    if request.path == '/admin/check':
        return response
    if auth is False:
        user = 'unidentified'
    else:
        user = g.user_id
    if request.method in ['GET', 'DELETE']:
        log_msg = "{0}-{1}-{2}-{3}".format(str(user), str(request), str(response.status), str(response.data))
    else:
        log_msg = "{0}-{1}-{2}-{3}-{4}".format(str(user), str(request), str(response.status), str(response.data), str(request.data))
    print(log_msg)
    return response


if __name__ == '__main__':
    print("Server on 5000 Port, MODE IN [DEV] START TIME:", dt.now())
    app.run(host='0.0.0.0', port=5000)





