
FROM python:3.10-slim

ENV PYTHONUNBUFFERED=1

RUN pip install -q cassandra-driver faker faker-commerce

COPY data_generator.py data_generator.py

CMD ["python", "data_generator.py"]