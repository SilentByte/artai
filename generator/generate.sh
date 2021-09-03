#!/usr/bin/env bash

set -e

if [[ ! -d "VQGAN-CLIP" ]]; then
    ./setup.sh
fi

cd VQGAN-CLIP
source ./venv/bin/activate

ARTAI_GEN_OUTPUT="$1"
ARTAI_GEN_PROMPT="$2"
ARTAI_GEN_SIZE="$3"
ARTAI_GEN_ITERATIONS="$4"

if [[ -z "$ARTAI_GEN_OUTPUT" || -z "$ARTAI_GEN_PROMPT" || -z "$ARTAI_GEN_SIZE" || -z "$ARTAI_GEN_ITERATIONS" ]]
then
    echo "ERROR: MISSING PARAMETERS"
    exit 1
fi

python generate.py \
       -o "$ARTAI_GEN_OUTPUT" \
       -p "$ARTAI_GEN_PROMPT" \
       -s "$ARTAI_GEN_SIZE" "$ARTAI_GEN_SIZE" \
       -i "$ARTAI_GEN_ITERATIONS" \
       -se "$ARTAI_GEN_ITERATIONS"
