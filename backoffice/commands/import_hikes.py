from app import app, db
from models.Hike import Hike
import click
import os
import pandas as pd
import requests
import time

@app.cli.command('import:hikes')
@click.argument('filename', default=None, required=True)
def importHikes(filename: str):
    filename = './csv/' + filename

    if not os.path.exists(filename):
        print("File not found")
        return
    
    try:
        batchSize = 1000
        batchCounter = 0
        df = pd.read_csv(filename, delimiter=';')
        df = df.where(pd.notnull(df), None)

        for index, row in df.iterrows():
            new_hike = Hike(
                osmId = int(row['osm_id']),
                name = row['name'] if row['name'] is not None else f"Hike {index}",
                firstNodeLat = str(row['first_node_lat']),
                firstNodeLon = str(row['first_node_lon']),
                lastNodeLat = str(row['last_node_lat']),
                lastNodeLon = str(row['last_node_lon'])
            )
            db.session.add(new_hike)
            
            if batchCounter % batchSize == 0:
                db.session.commit()
                print(f"Processed {batchCounter} records")

            batchCounter += 1

        db.session.commit()
        print('Data imported successfully')

    except Exception as e:
        db.session.rollback()
        print(f"Exception during processing: {e}")
        return

@app.cli.command('import:hikes:altitude')
def importAltitude():
    batch_size = 1000

    hikes = db.session.query(Hike).filter(Hike.positiveAltitude.is_(None), Hike.negativeAltitude.is_(None))
    total_hikes = hikes.count()

    for offset in range(0, total_hikes, batch_size):
        hikes_batch = db.session.query(Hike).filter(Hike.positiveAltitude.is_(None), Hike.negativeAltitude.is_(None)).offset(offset).limit(batch_size).all()
        print(f"Processing batch {offset // batch_size + 1} / {total_hikes // batch_size + 1}")

        for hike in hikes_batch:
            altitude_positive, altitude_negative = getAltitude(hike)
            hike.positiveAltitude = altitude_positive
            hike.negativeAltitude = altitude_negative
            print(f"Processed hike {hike.id} - {hike.name} - Positive: {altitude_positive}, Negative: {altitude_negative}")
            db.session.commit()
            pass

    print("All hikes processed")

def getAltitude(hike: Hike):
    print(f"Processing hike {hike.id} - {hike.name}")
    query = f"[out:json][timeout:25];(rel(id:{hike.osmId}););(._;>;);out geom;>;"
    response = requests.get("https://overpass-api.de/api/interpreter", params={'data': query})
    data = response.json()
    elements = data.get('elements', [])
    ways = [element for element in elements if element['type'] == 'way']
    print(f"Found {len(ways)} ways")

    preformattedData = []

    for way in ways:
        for geom in way['geometry']:
            preformattedData.append({
                'lat': geom['lat'],
                'lon': geom['lon'],
                'query': f"{geom['lat']},{geom['lon']}",
                'elevation': None
            })

    print(f"Found {len(preformattedData)} nodes")

    def chunk_list(data, chunk_size=100):
        chunked_data = []
        for i in range(0, len(data), chunk_size):
            chunked_data.append(data[i:i + chunk_size])
        return chunked_data
    
    chunks = chunk_list(preformattedData)
    print(f"Processing {len(chunks)} chunks")

    for chunk in chunks:
        time.sleep(1)
        query = '|'.join([node['query'] for node in chunk])
        response = requests.get(f"https://api.opentopodata.org/v1/srtm30m?locations={query}")
        data = response.json()
        for i, node in enumerate(chunk):
            node['elevation'] = data['results'][i]['elevation']

    print("Elevation data retrieved")

    altitude_positive = 0
    altitude_negative = 0

    for i in range(len(preformattedData) - 1):
        first_value = preformattedData[i]['elevation']
        second_value = preformattedData[i + 1]['elevation']

        difference = second_value - first_value

        if difference > 0:
            altitude_positive += difference
        elif difference < 0:
            altitude_negative += abs(difference)

    print(f"Positive altitude: {altitude_positive}, Negative altitude: {altitude_negative}")

    return altitude_positive, altitude_negative