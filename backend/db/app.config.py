import pymongo

conn = pymongo.MongoClient('localhost', 27017)
db = conn.get_database('stride')

clothes_collection = db.get_collection('clothes')