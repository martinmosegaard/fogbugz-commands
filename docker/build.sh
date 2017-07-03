#!/bin/bash
VERSION=$(grep VERSION ../lib/fogbugz/commands/version.rb | cut -d "'" -f 2)
docker build -t martinm/fogbugz:$VERSION .
docker tag martinm/fogbugz:$VERSION martinm/fogbugz:latest
