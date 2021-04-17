import json
import os
import uuid
import argparse
from azure.cosmos import CosmosClient


parser = argparse.ArgumentParser(
    description='Parse cheese json file to populate CosmosDb')
parser.add_argument('--url', help='The CosmosDb account URI')
parser.add_argument('--key', help='The CosmosDb account key')
parser.add_argument('--database', help='The CosmosDb database name')

args = parser.parse_args()

fileStream = open('data/fromagescsv-fromagescsv.json')
jsonDoc = json.loads(fileStream.read())

cosmos_url = args.url
cosmos_key = args.key
cosmos_db_name = args.database

cosmos_client = CosmosClient(cosmos_url, cosmos_key)
cosmos_db_client = cosmos_client.get_database_client(cosmos_db_name)
cosmos_cheeses_container = cosmos_db_client.get_container_client('cheeses')
cosmos_departments_container = cosmos_db_client.get_container_client(
    'departments')

departments = {}
for jsonElement in jsonDoc:
    departmentName = jsonElement['fields']['departement']

    if departmentName not in departments:
        print(f'Importing deparment {departmentName}...')
        newDepartmentId = str(uuid.uuid4())
        departments[departmentName] = newDepartmentId

        departmentDoc = {
            'id': newDepartmentId,
            'name': departmentName
        }

        if 'geo_point_2d' in jsonElement['fields']:
            departmentDoc['geo_point_2d'] = jsonElement['fields']['geo_point_2d']
        if 'geo_shape' in jsonElement['fields']:
            departmentDoc['geo_shape'] = jsonElement['fields']['geo_shape']

        cosmos_departments_container.upsert_item(departmentDoc)

    departmentId = departments[departmentName]
    cheeseId = str(uuid.uuid4())
    cheeseName = jsonElement['fields']['fromage']
    print(f'Importing chees {cheeseName}...')

    cheeseDoc = {
        'id': cheeseId,
        'departmentId': departmentId,
        'name': cheeseName
    }

    if 'lait' in jsonElement['fields']:
        cheeseDoc['milk'] = jsonElement['fields']['lait']
    if 'english_page' in jsonElement['fields']:
        cheeseDoc['wikiEn'] = jsonElement['fields']['english_page']
    if 'page_francaise' in jsonElement['fields']:
        cheeseDoc['wikiFr'] = jsonElement['fields']['page_francaise']
    

    cosmos_cheeses_container.upsert_item(cheeseDoc)
