from app import app, db
from models.Hike import Hike
import click
import os
import pandas as pd
from services.overpass import Overpass
import math

INFO = '\033[94m'
SUCCESS = '\033[92m'
WARNING = '\033[93m'
FAIL = '\033[91m'
END = '\033[0m'
NO_COLOR ='\x1b[0m'

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
                name = str(row['name']),
                firstNodeLat = str(row['first_node_lat']),
                firstNodeLon = str(row['first_node_lon']),
                lastNodeLat = str(row['last_node_lat']),
                lastNodeLon = str(row['last_node_lon']),
                hikingTime = None if math.isnan(row['hiking_time']) is True else str(row['hiking_time']),
                distance = None if math.isnan(row['distance']) is True else str(row['distance']),
                positiveAltitude = None if math.isnan(row['positive_altitude']) is True else str(row['positive_altitude']),
                negativeAltitude = None if math.isnan(row['positive_altitude']) is True else str(row['negative_altitude'])
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

@app.cli.command('import:hikes:metadata')
def importMetadata():
    batch_size = 1000

    hikes = db.session.query(Hike).filter(Hike.distance.is_(None), Hike.hikingTime.is_(None))
    total_hikes = hikes.count()

    for offset in range(0, total_hikes, batch_size):
        hikes_batch = hikes.offset(offset).limit(batch_size).all()
        print(f"{WARNING}Processing batch {offset // batch_size + 1} / {total_hikes // batch_size + 1}{NO_COLOR}")
        print(offset, len(hikes_batch))

        for hike in hikes_batch:
            print(f"{INFO}Processing hike {hike.id} - {hike.name}{NO_COLOR}")
            overpass = Overpass(hike.osmId)
            hike.distance = overpass.getDistance()
            hike.hikingTime = overpass.getDuration(float(hike.distance), 4.0)
            print(f"{SUCCESS}Processed hike {hike.id} - {hike.name}{NO_COLOR}")
            db.session.commit()

    print("All hikes processed")

@app.cli.command('import:hikes:altitude')
def importAltitude():
    batch_size = 1000

    hikes = db.session.query(Hike).filter(Hike.positiveAltitude.is_(None), Hike.negativeAltitude.is_(None))
    total_hikes = hikes.count()

    for offset in range(0, total_hikes, batch_size):
        hikes_batch = hikes.offset(offset).limit(batch_size).all()
        print(f"{WARNING}Processing batch {offset // batch_size + 1} / {total_hikes // batch_size + 1}\n{NO_COLOR}")

        for hike in hikes_batch:
            print(f"{INFO}Processing hike {hike.id} - {hike.name}{NO_COLOR}")
            overpass = Overpass(hike.osmId)
            overpass.getElevation()
            altitude_positive, altitude_negative = overpass.getAltitude()
            hike.positiveAltitude = altitude_positive
            hike.negativeAltitude = altitude_negative
            print(f"{SUCCESS}Processed hike {hike.id} - {hike.name}\n{NO_COLOR}")
            db.session.commit()

    print("All hikes processed")