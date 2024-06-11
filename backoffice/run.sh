#!/bin/sh

python3 -m pip install --no-cache-dir -r requirements.txt --root-user-action=ignore
python3 server.py