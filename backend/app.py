from flask import Flask, g, request
from gevent.pywsgi import WSGIServer
import logging
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
from backend.authentication.kakao import kakao
from backend.authentication.naver import naver
from flask_cors import CORS

dt = datetime.now()
log_name = str(dt.year) +'-'+ str(dt.month) +'-'+ str(dt.day)
logging.basicConfig(filename='log/'+ log_name+'.log', level=logging.DEBUG, format='%(asctime)s %(levelname)s %(name)s %(threadName)s : %(message)s')

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


@app.route('/')
def hello_world():
    g.user_id = 'test'
    return 'Hello World! CI TEST7 only develop'

@app.after_request
def log(response):
    LOG_FORMAT = "[%(asctime)-10s] - %(message)s"
    logging.basicConfig(filename="log/" + log_name + ".log", level=logging.DEBUG, format=LOG_FORMAT)
    logger = logging.getLogger("setting")
    log_msg = "{0}/{1}/{2}/{3}".format(str(g.user_id), str(request), str(response.status), str(response.get_data()))
    logger.info(log_msg)
    return response


if __name__ == '__main__':
    # Development
    # app.run(host='0.0.0.0', port=5000)

    # Production
    print("Server on 5000 Port")
    http_server = WSGIServer(('', 5000), app)
    http_server.serve_forever()
