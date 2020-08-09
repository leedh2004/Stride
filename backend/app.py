from flask import Flask
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.api_v1.dressroom import dressroom
from backend.api_v1.coordination import coordination
from backend.api_v1.login import login
from backend.api_v1.kakao import kakao

from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r'*': {'origins': '*'}})

app.register_blueprint(dressroom, url_prefix='/dressroom')
app.register_blueprint(coordination, url_prefix='/coordination')
app.register_blueprint(login, url_prefix='/login')
app.register_blueprint(kakao, url_prefix='/kakao')


@app.route('/')
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
