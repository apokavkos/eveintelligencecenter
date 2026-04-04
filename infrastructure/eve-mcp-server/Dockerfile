FROM python:3.11-slim

WORKDIR /app

RUN pip install mcp pymysql

COPY server.py /app/server.py

EXPOSE 8000

CMD ["python", "server.py"]
