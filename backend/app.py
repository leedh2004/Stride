from flask import Flask
from api_v1.dressroom import dressroom
from api_v1.coordination import coordination

app = Flask(__name__)
app.register_blueprint(dressroom, url_prefix='/dressroom')
app.register_blueprint(coordination, url_prefix='/coordination')


@app.route('/')
def hello_world():
    return 'Hello World!'


if __name__ == '__main__':
    app.run()
