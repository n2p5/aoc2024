#!/bin/bash

mkdir -p "day_${1}"/part_{1,2}

for i in {1..2}; do
    touch "day_${1}/part_${i}/instructions.txt"
    touch "day_${1}/part_${i}/main.jl"
done
