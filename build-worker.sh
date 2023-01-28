#!/usr/bin/env bash
cd ./frontend/web_worker
browserify main.js -o ../web/workerLib.js
