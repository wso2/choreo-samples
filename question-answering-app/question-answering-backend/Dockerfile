FROM python:3.11-alpine

WORKDIR /python-docker

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

COPY . .

RUN addgroup -g 10016 choreo && \
    adduser  --disabled-password  --no-create-home --uid 10016 --ingroup choreo choreouser

USER 10016

EXPOSE 5000

CMD ["flask", "run", "--host=0.0.0.0"]
