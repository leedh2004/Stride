from flask import Blueprint, jsonify, request, redirect, url_for
import json
from bson import ObjectId, json_util

auth = Blueprint('auth', __name__)

@auth.route('/oauth', methods=['GET'])
def login():
    code = str(request.args.get('code'))
    print(request.args)
    return str(code)

