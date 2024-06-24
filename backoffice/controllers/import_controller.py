from flask import request, json
import pandas as pd
from app import app, db
from models.Hike import Hike
import os

@app.route('/import_csv', methods=['POST'])
def import_csv():
    file_path = request.form.get('file_path', './csv/all_france_hiking_no_geom.csv')

    if not os.path.exists(file_path):
        response = app.response_class(
            response=json.dumps({
                'message': 'File not found'
            }),
            status=404,
            mimetype='application/json'
        )
        return response

    try:
        df = pd.read_csv(file_path, delimiter=';')
        df = df.where(pd.notnull(df), None)

        expected_columns = {'FID', 'osm_id', 'name'}
        if not expected_columns.issubset(df.columns):
            response = app.response_class(
                response=json.dumps({
                    'message': 'CSV file is missing required columns'
                }),
                status=400,
                mimetype='application/json'
            )
            return response

        for index, row in df.iterrows():
            try:
                if row['FID'] is None or row['osm_id'] is None:
                    print(f"Missing required field in row {index}: {row.to_dict()}")

                new_hike = Hike(
                    FID=row['FID'],
                    osmId=int(row['osm_id']),
                    name=row['name'],
                )
                db.session.add(new_hike)
            except Exception as e:
                import traceback
                traceback.print_exc()
                db.session.rollback()
                print(f"Error adding row {index}: {row.to_dict()}")
                print(f"Exception: {e}")

        db.session.commit()
        response = app.response_class(
            response=json.dumps({
                'message': 'Data imported successfully'
            }),
            status=200,
            mimetype='application/json'
        )
        return response

    except Exception as e:
        print(f"Exception during processing: {e}")
        response = app.response_class(
            response=json.dumps({
                'message': str(e)
            }),
            status=500,
            mimetype='application/json'
        )
        return response
