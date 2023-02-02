#!/usr/bin/env bash
cd backend
cargo run -- -c mongodb://localhost:27017 -p 8000 -s NJNXvuUqt+o95G0fRhJTFd5yhAVen012o8kb9NofGN8= $@
