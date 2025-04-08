FROM ubuntu:22.04
USER root
RUN apt-get update -y && apt-get install -y curl && apt-get install -y sudo
COPY . ~/
RUN chmod 777 ~/netmonitor.sh
# To keep it running
ENTRYPOINT ["./~/netmonitor.sh", "eth0"]
# ENTRYPOINT ["tshark", "-i", "eth0"]
