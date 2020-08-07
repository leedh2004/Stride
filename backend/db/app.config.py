import pymongo
import psycopg2

service_conn = psycopg2.connect(database='Stride', user='', password='', host='', port='5432')
conn = pymongo.MongoClient('localhost', 27017)
db = conn.get_database('stride')

clothes_collection = db.get_collection('clothes')
