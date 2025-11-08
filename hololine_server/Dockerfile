# Build stage
FROM dart:3.5.0 AS build
WORKDIR /app
COPY . .

RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

# Final stage
FROM debian:bullseye-slim

ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith
ENV PORT=8080

WORKDIR /app

COPY --from=build /app/bin/server server
COPY --from=build /app/config/ config/
COPY --from=build /app/web/ web/
COPY --from=build /app/migrations/ migrations/
COPY --from=build /app/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

ENTRYPOINT ["./server", "--mode=production", "--server-id=default", "--logging=normal", "--role=monolith"]
