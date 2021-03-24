import json
import os
import uuid
from azure.cosmos import CosmosClient


fileStream = open('../../data/fromagescsv-fromagescsv.json')
jsonDoc = json.loads(fileStream.read())

cosmos_url = os.environ['COSMOS_ACCOUNT_URI']
cosmos_key = os.environ['COSMOS_ACCOUNT_KEY']
cosmos_db_name = os.environ['COSMOS_DB_NAME']

cosmos_client = CosmosClient(cosmos_url, cosmos_key)
cosmos_db_client = cosmos_client.get_database_client(cosmos_db_name)
cosmos_cheeses_container = cosmos_db_client.get_container_client('cheeses')
cosmos_departments_container = cosmos_db_client.get_container_client(
    'departments')

departments = {}
for jsonElement in jsonDoc:
    departmentName = jsonElement['fields']['departement']
    print(jsonElement['fields']['geo_shape']['coordinates'])
    if departmentName not in departments:
        departmentId = str(uuid.uuid4())
        departments[departmentName] = departmentId

        cosmos_departments_container.upsert_item({
            'id': departmentId,
            'name': departmentName,
            'geo-point-2d': jsonElement['fields']['geo_point_2d'],
            'geo-shape': jsonElement['fields']['geo_shape']
        })