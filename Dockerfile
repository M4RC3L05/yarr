FROM golang:1.24.5-alpine AS builder

WORKDIR /src

RUN apk add --no-cache build-base git

COPY . .

RUN make host

FROM alpine:latest

RUN apk add --no-cache ca-certificates
RUN update-ca-certificates

RUN addgroup --gid 1000 main
RUN adduser --uid 1000 --disabled-password main --ingroup main

USER main

WORKDIR /home/yarr

RUN mkdir /home/yarr/data

COPY --chown=main:main --from=builder /src/out/yarr .

CMD ["/home/yarr/yarr"]
