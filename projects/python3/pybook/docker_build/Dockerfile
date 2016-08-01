# Dockerfile for py-book-teacher

FROM python:3.5

RUN mkdir /app

COPY ./py-book-teacher /app/

WORKDIR /app

RUN pip install -r pip_packages.txt

# After install package,
#root@0041dea42a17:/app# find / -name "htmldom"
#/usr/local/lib/python3.5/site-packages/htmldom
