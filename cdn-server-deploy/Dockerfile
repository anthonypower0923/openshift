FROM ubuntu:22.04
USER root
RUN apt-get update -y && apt-get install -y curl && apt-get install sudo -y && apt-get install -y tshark
ENTRYPOINT ["tshark", "-i", "eth0"]
