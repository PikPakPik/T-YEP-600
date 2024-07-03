from app import app, db
import click
import os
import pandas as pd
from models.Hike import Hike

@app.cli.command('import:hikes')
@click.argument('filename', required=True)
def hello(filename=None):
    filename = './csv/' + filename

    if not os.path.exists(filename):
        print("File not found")
        return
    
    try:
        df = pd.read_csv(filename, delimiter=';')
        df = df.where(pd.notnull(df), None)

        expected_columns = {'FID', 'osm_id', 'name'}
        if not expected_columns.issubset(df.columns):
            return

        for index, row in df.iterrows():
            try:
                if row['FID'] is None or row['osm_id'] is None:
                    print(f"Missing required field in row {index}: {row.to_dict()}")

                new_hike = Hike(
                    osmId=int(row['osm_id']),
                    name=row['name'],
                )
                db.session.add(new_hike)
            except Exception as e:
                db.session.rollback()
                print(f"Error adding row {index}: {row.to_dict()}")
                print(f"Exception: {e}")

        db.session.commit()
        print('Data imported successfully')
        return

    except Exception as e:
        print(f"Exception during processing: {e}")
        return