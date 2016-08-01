# Dockerfile for golang
#  App is go-book-teacher

#FROM golang:1.6-onbuild
FROM golang:1.6

ARG redisHostName=default-redis-server
ARG testValue1=defaultaaaaa
ARG testValue2=defaultbbbbb

COPY ./go-book-teacher /go/src/github.com/hiromaily/go-book-teacher/

#<password>@<hostname>:<port>
ENV REDIS_URL=redis://h:password@${redisHostName}:6379
ENV TEST_VALUE1=${testValue1}
ENV TEST_VALUE2=${testValue2}

WORKDIR /go/src/github.com/hiromaily/go-book-teacher

#Debug
#RUN pwd
#RUN ls -al

#
RUN go get -d -v ./... && go build -v -o /go/bin/book ./cmd/book/

#CMD ["book"]
