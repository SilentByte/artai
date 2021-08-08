"""
ArtAI -- An Generative Art Project using Artificial Intelligence
Copyright (c) 2021 SilentByte <https://silentbyte.com/>
"""

import os
import sqlite3

from typing import Optional, List
from uuid import UUID, uuid4
from datetime import datetime

from dotenv import load_dotenv
from fastapi import FastAPI, status
from pydantic import BaseModel

load_dotenv()

ARTAI_DATA_DIR = os.getenv('ARTAI_DATA_DIR', '/app/data')


class JobModel(BaseModel):
    id: UUID
    author: str
    prompt: str
    created_on: datetime
    completed_on: Optional[datetime]


class JobInput(BaseModel):
    author: str
    prompt: str
    twitter_json: str


class JobQuery(BaseModel):
    limit: Optional[int]
    completed: Optional[bool]


class Repository:
    def __init__(self, filename: str):
        self._db = sqlite3.connect(filename)

        with self._db:
            self._db.execute('''
                CREATE TABLE IF NOT EXISTS job (
                    id              TEXT PRIMARY KEY,
                    author          TEXT NOT NULL,
                    prompt          TEXT NOT NULL,
                    created_on      TEXT NOT NULL,
                    completed_on    TEXT NULL,
                    twitter_json    TEXT NOT NULL
                );
            ''')

            self._db.execute('''
                CREATE INDEX IF NOT EXISTS job_created_on_index ON job (created_on DESC);
            ''')

            self._db.execute('''
                CREATE INDEX IF NOT EXISTS job_completed_on_index ON job (completed_on);
            ''')

    def create_job(self, job: JobInput) -> JobModel:
        model = JobModel(
            id=uuid4(),
            author=job.author,
            prompt=job.prompt,
            created_on=datetime.utcnow(),
            completed_on=None,
        )

        with self._db:
            self._db.execute('''
                INSERT INTO job (id, author, prompt, created_on, twitter_json) VALUES (?, ?, ?, ?, ?)
            ''', [str(model.id), model.author, model.prompt, model.created_on.isoformat(), job.twitter_json])

        return model

    def complete_job(self, job_id: UUID) -> None:
        completed_on = datetime.utcnow()
        print(job_id)
        with self._db:
            self._db.execute('''
                UPDATE job SET completed_on = ? WHERE id = ?
            ''', [completed_on.isoformat(), str(job_id)])

    def query_jobs(self, query: JobQuery) -> List[JobModel]:
        completed = query.completed if query.completed is not None else True
        limit = min(max(1, query.limit or 0), 100)

        with self._db:
            cursor = self._db.execute('''
                SELECT id, author, prompt, created_on, completed_on
                FROM job
                WHERE CASE WHEN ? THEN completed_on IS NOT NULL ELSE completed_on IS NULL END
                ORDER BY CASE WHEN ? THEN completed_on ELSE created_on END DESC
                LIMIT ?
            ''', [int(completed), int(completed), limit])

            return [
                JobModel(
                    id=UUID(row[0]),
                    author=row[1],
                    prompt=row[2],
                    created_on=datetime.fromisoformat(row[3]),
                    completed_on=datetime.fromisoformat(row[4]) if row[4] is not None else None,
                )
                for row in cursor.fetchall()
            ]


app = FastAPI()
repo = Repository(os.path.join(ARTAI_DATA_DIR, 'artai.sqlite'))


@app.get('/jobs')
async def query_jobs(query: JobQuery):
    return repo.query_jobs(query)


@app.post('/job', status_code=status.HTTP_201_CREATED)
async def create_job(job: JobInput):
    return repo.create_job(job)


@app.post('/job/{job_id}/complete')
async def complete_job(job_id: UUID):
    return repo.complete_job(job_id)
