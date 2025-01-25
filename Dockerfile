FROM golang:latest AS builder
ENV GO111MODULE=on

WORKDIR /trade-bot
COPY . .

RUN go mod tidy
RUN make build

FROM ubuntu:latest

RUN apt update && apt install -y libpq5 ca-certificates

WORKDIR /app

COPY --from=builder /trade-bot/dist/bot .

COPY --from=builder /trade-bot/config.default.toml .
COPY --from=builder /trade-bot/logo.png .

RUN mkdir layout
COPY --from=builder /trade-bot/layout ./layout

EXPOSE 8080

RUN chmod a+x ./bot

ENTRYPOINT ["./bot", "run"]
