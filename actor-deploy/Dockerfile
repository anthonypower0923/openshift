FROM ubuntu:22.04
USER root

RUN apt-get update -y && apt-get install -y ipip \
    && apt-get install net-tools && apt-get install -y git \
    && apt-get install -y cmake && apt-get install -y build-essential \
    && apt-get install -y iproute2 && apt-get install -y sudo && apt-get install -y kmod

# RUN sudo apt install linux-generic -y
# RUN dpkg -l | grep linux-image-.*-generic | sort -k3 | tail -n1 | awk '{system ("sudo apt-get install --reinstall " $2)}'
# RUN sudo apt-get install --reinstall linux-modules-5.15.0-136-generic -y
# RUN sudo apt-get install --reinstall linux-modules-extra-5.15.0-136-generic -y

RUN sysctl -w net.ipv4.ip_forward=1
# RUN chmod 777 /lib/modules/5.15.0-136-generic/kernel/net/ipv4/ip_gre.ko
# RUN mkdir /lib/modules/6.10.14-linuxkit/
# RUN cp /lib/modules/5.15.0-136-generic/kernel/net/ipv4/ip_gre.ko /lib/modules/
# RUN sudo depmod $(uname -r)
# RUN sudo cp -a /lib/modules/5.15.0-136-generic/. /lib/modules/$(uname -r)/ 
# RUN sudo echo 1 > /proc/sys/kernel/sysrq && sudo echo x > /proc/sysrq-trigger
# RUN sudo modprobe ip_gre.ko
# RUN insmod /lib/modules/5.15.0-136-generic/kernel/net/ipv4/ip_gre.ko
RUN sudo ip tunnel add gre1 mode gre remote 10.131.0.112 local 127.0.0.1 ttl 25
RUN sudo ip addr add 10.0.0.1/30 dev gre1
RUN ip link set dev gre1 up

# RUN git clone https://github.com/anthonypower0923/FYP.git
# WORKDIR /FYP/modified-hipercontracer
# RUN cmake .
# RUN make
# Define the command to start the service
# ENTRYPOINT ["ls" ,"/lib/modules/6.10.14-linuxkit/kernel/net/ipv4" ]
# CMD ["sleep", "1.5h"]
# ENTRYPOINT ["hipercontracer", "--source 10.131.0.112 --destination 192.168.64.26 -T --tracerouteinterval 10000 --tracerouteduration 1000"]
