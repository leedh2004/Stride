import pymongo
import psycopg2
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
sys.path.append('../../../../')
from config.oauthconfig import *

service_conn = psycopg2.connect(
    database=PSQL_DB,
    user=PSQL_User,
    password=PSQL_PW,
    host=PSQL_Host,
    port=PSQL_Port)
conn = pymongo.MongoClient('localhost', 27017)
db = conn.get_database('stride')

clothes_collection = db.get_collection('clothes')
