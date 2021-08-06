"""
ArtAI -- An Generative Art Project using Artificial Intelligence
Copyright (c) 2021 SilentByte <https://silentbyte.com/>
"""

import os
import re
import json
import logging

import requests
import tweepy

from dotenv import load_dotenv
from better_profanity import profanity

load_dotenv()

ARTAI_HUB_ENDPOINT_URL = os.environ['ARTAI_HUB_ENDPOINT_URL'].rstrip('/')
ARTAI_FILTER_KEYWORDS = os.environ['ARTAI_FILTER_KEYWORDS'].split(',')

ARTAI_TWITTER_CONSUMER_KEY = os.environ['ARTAI_TWITTER_CONSUMER_KEY']
ARTAI_TWITTER_CONSUMER_SECRET = os.environ['ARTAI_TWITTER_CONSUMER_SECRET']
ARTAI_TWITTER_ACCESS_TOKEN = os.environ['ARTAI_TWITTER_ACCESS_TOKEN']
ARTAI_TWITTER_ACCESS_SECRET = os.environ['ARTAI_TWITTER_ACCESS_SECRET']

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)

profanity.load_censor_words()
profanity.add_censor_words(ARTAI_FILTER_KEYWORDS)


def clean_status_text(text: str) -> str:
    # Basic profanity filter to reduce the chance of explicit images being produced.
    text = profanity.censor(text, '')

    for w in ARTAI_FILTER_KEYWORDS:
        text = re.sub(re.escape(w), '', text, 0, re.IGNORECASE)

    return text


def create_job(status):
    log.info('Creating job...')
    response = requests.post(f'{ARTAI_HUB_ENDPOINT_URL}/job', json={
        'author': status.author.screen_name,
        'prompt': clean_status_text(status.text),
        'twitter_json': json.dumps(getattr(status, '_json', {})),
    })

    if response.ok:
        log.info('Job created: (%s) %s', response.status_code, response.json())
    else:
        log.error('Job creation failed with status %s', response.status_code)


class ArtAIStreamListener(tweepy.StreamListener):
    def on_status(self, status):
        log.info('Received status: %s', {
            'id': status.id,
            'created_at': status.created_at,
            'source_url': status.source_url,
            'author_name': status.author.name,
            'author_screen_name': status.author.screen_name,
            'text': status.text,
        })

        create_job(status)

    def on_error(self, status_code):
        log.error('Error occurred with status %s', status_code)


def start_stream_listener() -> None:
    auth = tweepy.OAuthHandler(ARTAI_TWITTER_CONSUMER_KEY, ARTAI_TWITTER_CONSUMER_SECRET)
    auth.set_access_token(ARTAI_TWITTER_ACCESS_TOKEN, ARTAI_TWITTER_ACCESS_SECRET)

    stream = tweepy.Stream(
        auth=auth,
        listener=ArtAIStreamListener(),
    )

    log.info('Starting stream, listening for %s', ARTAI_FILTER_KEYWORDS)
    stream.filter(track=ARTAI_FILTER_KEYWORDS)


if __name__ == '__main__':
    while True:
        try:
            start_stream_listener()
        except Exception as e:
            log.exception("Twitter stream listener crashed", exc_info=e)
