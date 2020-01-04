#!/bin/sh
cd `dirname $0`
export ERL_MAX_PORTS=2048
export APP_ENV="dev"
exec erl +K true -pa $(pwd)/ebin $(find $(pwd)/deps -type d -name ebin | xargs) -s egame
