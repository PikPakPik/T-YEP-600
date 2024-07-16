import io
from app import app, db
from dtos.paginator import PaginatorDTO
from models.Hike import Hike
from models.User import User
from models.Files import Files
from flask import json, request
from flask_login import login_required, current_user
from services.minio import MinioClient
import requests

@app.route("/api/hike/favorites", methods = ['GET'])
@login_required
def get_favorite_hike():
    page = request.args.get('page', 1, type=int)
    limit = request.args.get('limit', 25, type=int)
    if limit > 1000:
        return app.response_class(
            response=json.dumps({
                'i18n': 'pagination.limit.invalid'
            }),
            status=400,
            mimetype='application/json'
        )

    favorite_hikes = db.session.query(Hike).join(User.user_hike).join(User).filter(User.id == current_user.id)
    totalItems = favorite_hikes.count()
    hikes = favorite_hikes.offset((page - 1) * limit).limit(limit).all()
    hikes = [hike.serializeFavorite() for hike in hikes]

    paginator = PaginatorDTO(hikes, totalItems, limit, page)

    return app.response_class(
        response=json.dumps(paginator.serialize()),
        status=200,
        mimetype='application/json'
    )

@app.route("/api/hike/<int:hike_id>/favorite", methods = ['POST'])
@login_required
def add_favorite_hike(hike_id):
    hike = db.session.get(Hike, hike_id)
    if not hike:
        return app.response_class(
            response=json.dumps({
                'i18n': 'hike.not_found'
            }),
            status=404,
            mimetype='application/json'
        )
    
    favorite_exists = db.session.query(
        db.exists().where(
            db.and_(
                User.user_hike.c.user_id == current_user.id,
                User.user_hike.c.hike_id == hike_id
            )
        )
    ).scalar()

    if favorite_exists:
        return app.response_class(
            response=json.dumps({
                'i18n': 'hike.favorite.already_exists'
            }),
            status=400,
            mimetype='application/json'
        )

    current_user.hikes.append(hike)
    db.session.commit()
    return app.response_class(
        response=json.dumps({
            'i18n': 'hike.favorite.added'
        }),
        status=200,
        mimetype='application/json'
    )

@app.route("/api/hike/<int:hike_id>/favorite", methods = ['DELETE'])
@login_required
def delete_favorite_hike(hike_id):
    hike = db.session.get(Hike, hike_id)
    if not hike:
        return app.response_class(
            response=json.dumps({
                'i18n': 'hike.not_found'
            }),
            status=404,
            mimetype='application/json'
        )

    favorite_exists = db.session.query(
        db.exists().where(
            db.and_(
                User.user_hike.c.user_id == current_user.id,
                User.user_hike.c.hike_id == hike_id
            )
        )
    ).scalar()

    if not favorite_exists:
        return app.response_class(
            response=json.dumps({
                'i18n': 'hike.favorite.does_not_exist'
            }),
            status=400,
            mimetype='application/json'
        )

    current_user.hikes.remove(hike)
    db.session.commit()
    return app.response_class(
        response=json.dumps({
            'i18n': 'hike.favorite.deleted'
        }),
        status=200,
        mimetype='application/json'
    )

@app.route("/api/hikes", methods=['GET'])
def get_hikes():
    page = request.args.get('page', 1, type=int)
    limit = request.args.get('limit', 25, type=int)
    if limit > 1000:
        return app.response_class(
            response=json.dumps({
                'i18n': 'pagination.limit.invalid'
            }),
            status=400,
            mimetype='application/json'
        )

    hikes_query = db.session.query(Hike).order_by(Hike.createdAt)
    totalItems = hikes_query.count()
    hikes = hikes_query.offset((page - 1) * limit).limit(limit).all()
    hikes = [hike.serialize() for hike in hikes]

    paginator = PaginatorDTO(hikes, totalItems, limit, page)

    return app.response_class(
        response=json.dumps(paginator.serialize()),
        status=200,
        mimetype='application/json'
    )

@app.route("/api/hike/<int:hike_id>", methods=['GET'])
def get_hike(hike_id):
    hike = db.session.query(Hike).get(hike_id)
    
    if not hike:
        return app.response_class(
            response=json.dumps({
                'i18n': 'hike.not_found'
            }),
            status=404,
            mimetype='application/json'
        )

    return app.response_class(
        response=json.dumps(hike.serialize()),
        status=200,
        mimetype='application/json'
    )

@app.route('/api/hike/<int:hike_id>/image', methods=['POST'])
@login_required
def upload_image(hike_id):
    hike = db.session.query(Hike).get(hike_id)
    
    if not hike:
        return app.response_class(
            response=json.dumps({
                'i18n': 'hike.not_found'
            }),
            status=404,
            mimetype='application/json'
        )
    
    if 'file' not in request.files:
        return app.response_class(
            response=json.dumps({
                'i18n': 'validator.file.not_found'
            }),
            status=400,
            mimetype='application/json'
        )

    file = request.files['file']
    allowed_content_types = ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'image/webp', 'image/tiff', 'image/bmp']
    if file.content_type not in allowed_content_types:
        return app.response_class(
            response=json.dumps({
                'i18n': 'validator.file.invalid_content_type',
                'expected': allowed_content_types,
            }),
            status=400,
            mimetype='application/json'
        )

    client = MinioClient().uploadHikeImage(hike_id, file)
    if client is None:
        return app.response_class(
            response=json.dumps({'i18n': 'hike.image.error'}),
            status=500,
            mimetype='application/json'
        )

    new_file = Files(imgName=client, hikeId=hike_id)
    db.session.add(new_file)
    db.session.commit()

    return app.response_class(
        response=json.dumps({'i18n': 'hike.image.uploaded'}),
        status=200,
        mimetype='application/json'
    )

@app.route("/api/hike/<int:hike_id>/geometry", methods = ['GET'])
def get_hike_geometry(hike_id):
    hike = db.session.get(Hike, hike_id)
    if not hike:
        return app.response_class(
            response=json.dumps({
                'i18n': 'hike.not_found'
            }),
            status=404,
            mimetype='application/json'
        )

    try:
        query = f"[out:json][timeout:25];(rel(id:{hike.osmId}););(._;>;);out geom;>;"
        response = requests.get("https://overpass-api.de/api/interpreter", params={'data': query})
        data = response.json()
        elements = data.get('elements', [])
        ways = [element for element in elements if element['type'] == 'way']
        geometries = []
        for way in ways:
            for geom in way['geometry']:
                geometries.append({
                    'lat': geom['lat'],
                    'lon': geom['lon'],
                })

        return app.response_class(
            response=json.dumps(geometries),
            status=200,
            mimetype='application/json'
        )
    except Exception as e:
        return app.response_class(
            response=json.dumps({
                'i18n': 'hike.geometry.error'
            }),
            status=500,
            mimetype='application/json'
        )