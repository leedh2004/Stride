import sys
from flask import Blueprint, jsonify, render_template
import requests
import json
from bson import ObjectId, json_util
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from backend.authentication.auth import *
apple = Blueprint('apple', __name__)


@apple.route('/oauth', methods=['GET'])
def login():
    code = str(request.args.get('code'))

