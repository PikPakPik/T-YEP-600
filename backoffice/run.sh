#!/bin/sh

python3 -m pip install --no-cache-dir -r requirements.txt --root-user-action=ignore
python3 server.py

flask database:create
flask database:fixtures
flask import:hikes all_france_hiking_no_geom.csv