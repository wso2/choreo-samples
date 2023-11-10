FROM python:3.12.0a6-alpine3.16

WORKDIR /app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod -x /app/consumer.py;

USER 10014

CMD [ "python", "-u", "/app/consumer.py" ]

