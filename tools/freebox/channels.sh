#!/bin/zsh

#FNAME=channels_small
FNAME=channels
FBMOD="Freebox Ultra"

#jq --stream --arg fbmod $FBMOD -f queries.jq ${FNAME}.json >${FNAME}_out.json
jq  --arg fbmod $FBMOD -f queries.jq ${FNAME}.json | jq -s '.' >${FNAME}_out.json


exit 0

#       cat:   .details.categories |tostring,
#opt:
