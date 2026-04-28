#!/bin/bash
cd /home/ec2-user/flask-app
export FLASK_APP=app.py
nohup flask run --host=0.0.0.0 --port=5000 > /home/ec2-user/flask.log 2>&1 &
