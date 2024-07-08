from app import app, db
from models.Hike import Hike
import click
import os
import pandas as pd

@app.cli.command('import:hikes')
@click.argument('filename', required=True)
def importHikes(filename=None):
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
                name = row['name'] if row['name'] is not None else f"Hike {index}"
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