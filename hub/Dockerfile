
FROM python:3.9.6-slim-buster

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY artaihub.py .

CMD ["uvicorn", "artaihub:app", "--host", "0.0.0.0", "--port", "8000"]
