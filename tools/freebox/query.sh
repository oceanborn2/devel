#!/bin/bash

rm -f output.json output.csv
jq -f query.jq static_lease.json >output.json && jq -r -f flatten.jq output.json >output.csv
