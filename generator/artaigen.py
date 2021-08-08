"""
ArtAI -- An Generative Art Project using Artificial Intelligence
Copyright (c) 2021 SilentByte <https://silentbyte.com/>
"""

import os
import time
import subprocess
import logging
import requests

from dotenv import load_dotenv
from shutil import move

load_dotenv()

ARTAI_GEN_ENDPOINT_URL = os.environ['ARTAI_GEN_ENDPOINT_URL'].rstrip('/')
ARTAI_GEN_OUTPUT_DIR = os.environ['ARTAI_GEN_OUTPUT_DIR']
ARTAI_GEN_TMP_FILE = os.getenv('', os.path.join(os.path.dirname(os.path.realpath(__file__)), '~tmp.png'))
ARTAI_GEN_SIZE = os.environ['ARTAI_GEN_SIZE']
ARTAI_GEN_ITERATIONS = os.environ['ARTAI_GEN_ITERATIONS']

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)

log.info('Setting up VQGAN-CLIP...')
subprocess.check_call(['./setup.sh'])

log.info('Starting generator service...')
while True:
    try:
        response = requests.get(f'{ARTAI_GEN_ENDPOINT_URL}/jobs', json={
            "limit": 1,
            "completed": False,
        })

        response.raise_for_status()

        data = response.json()
        if len(data) == 0:
            log.info("Job's done, waiting...")
            time.sleep(2)
            continue

        job = data[0]
        id = job['id']
        prompt = job['prompt']

        log.info("Generating %s %s", id, prompt)
        subprocess.check_call(['./generate.sh', ARTAI_GEN_TMP_FILE, prompt, ARTAI_GEN_SIZE, ARTAI_GEN_ITERATIONS])

        move(ARTAI_GEN_TMP_FILE, os.path.join(ARTAI_GEN_OUTPUT_DIR, f'{id}.png'))

        requests.post(f'{ARTAI_GEN_ENDPOINT_URL}/job/{id}/complete') \
            .raise_for_status()

        log.info(f"Completed job {id} with prompt '{prompt}'")

    except Exception as e:
        log.exception('Exception occurred', exc_info=e)
        time.sleep(2)
