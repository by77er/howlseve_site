FROM ghcr.io/gleam-lang/gleam:v1.5.1-erlang-alpine AS builder

COPY . /build/

RUN cd /build \
  && apk add fuse3 ca-certificates sqlite gcc build-base \
  && gleam export erlang-shipment \
  && mv build/erlang-shipment /app \
  && mv priv /app \
  && rm -r /build \
  && apk del gcc build-base

FROM ghcr.io/gleam-lang/gleam:v1.5.1-erlang-alpine AS runner

COPY --from=builder /app /app
EXPOSE 8000
WORKDIR /app
CMD ["./entrypoint.sh", "run"]