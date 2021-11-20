FROM rust:latest as backend_builder
WORKDIR /usr/src/backend
COPY /backend .
RUN cargo build --release

FROM ubuntu:latest as frontend_builder
RUN apt update && apt install -y curl git unzip xz-utils zip
USER root
WORKDIR /home/root

RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/root/flutter/bin"
RUN flutter doctor
COPY /frontend ./frontend
WORKDIR /home/root/frontend
RUN flutter build web

FROM ubuntu:latest

WORKDIR /root
COPY --from=backend_builder /usr/src/backend/target/release/backend ./backend/
COPY --from=frontend_builder /home/root/frontend/build/web/ ./web_build

WORKDIR /root/backend
CMD ./backend -p $PORT -a 0.0.0.0 -c $DB_STRING
