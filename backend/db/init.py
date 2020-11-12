import psycopg2
import sys
sys.path.append('../')
sys.path.append('../../')
sys.path.append('../../../')
from config.oauthconfig import *
from contextlib import contextmanager
from elasticsearch import Elasticsearch

@contextmanager
def db_connect():
    service_conn = psycopg2.connect(
        database=PSQL_DB,
        user=PSQL_User,
        password=PSQL_PW,
        host=PSQL_Host,
        port=PSQL_Port)
    cursor = service_conn.cursor()
    try:
        yield (service_conn, cursor)
    finally:
        cursor.close()
        service_conn.close()


@contextmanager
def es_connect():
    es_connection = Elasticsearch(es_endpoint)
    try:
        yield (es_connection)
    finally:
        es_connection.close()