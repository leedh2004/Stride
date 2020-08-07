from flask import Flask
import sys
sys.path.append('../')
sys.path.append('../../')
from backend.api_v1.dressroom import dressroom
from backend.api_v1.coordination import coordination
from backend.api_v1.auth import auth
from flask_cors import CORS

app = Flask(__name__)
CORS(app, resources={r'*': {'origins': '*'}})

app.register_blueprint(dressroom, url_prefix='/dressroom')
app.register_blueprint(coordination, url_prefix='/coordination')
app.register_blueprint(auth, url_prefix='/auth')


@app.route('/')
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
