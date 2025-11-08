FROM dart:stable AS build

WORKDIR /server
COPY hololine_server .

# Build our server
RUN dart pub get
RUN dart compile exe bin/main.dart -o bin/server

WORKDIR /web
COPY hololine_flutter/ .
# Copy our client package code. The flutter app depends on it
COPY hololine_client/ ../hololine_client/

# Install Flutter SDK
RUN apt-get update && apt-get -y install curl git unzip xz-utils zip libglu1-mesa
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="${PATH}:/usr/local/flutter/bin"

ARG SERVERPOD_URL

# Run web build
# RUN flutter pub get
# RUN flutter build web --dart-define SERVERPOD_URL=${SERVERPOD_URL}

FROM alpine:latest

ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy dart runtime and build artifacts
COPY --from=build /runtime/ /
COPY --from=build /server/bin/server server
COPY --from=build /server/confi[g]/ config/
COPY --from=build /server/we[b]/ web/
COPY --from=build /server/migration[s]/ migrations/

#COPY --from=build /web/build/web/ web/

EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

ENTRYPOINT ./server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role --apply-migrations