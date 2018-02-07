FROM ubuntu:xenial as builder

RUN /bin/bash -c 'apt-get update; \
apt-get install -y libminiupnpc-dev qt5-default qt5-qmake qtbase5-dev-tools qttools5-dev-tools \
libboost-system-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev \
libboost-test-dev libdb5.3++-dev git build-essential libssl-dev'

RUN /bin/bash -c 'useradd -m -s /bin/bash ecadev'
RUN /bin/bash -c 'gpasswd -a ecadev sudo'

USER ecadev
WORKDIR /home/ecadev
RUN git clone -b nogui --single-branch https://github.com/Electra-project/Electra.git; \
    cd Electra; qmake GUI=0; make

RUN objdump -p /home/ecadev/Electra/src/Electra-qt | grep NEEDED | awk '{ print $2 }' | xargs dpkg -S | cut -d':' -f 1 > /home/ecadev/Electra/libs

FROM ubuntu:xenial

COPY --from=builder /home/ecadev/Electra/libs /root/libs
COPY --from=builder /home/ecadev/Electra/Electra.conf /root/.Electra/Electra.conf
COPY --from=builder /home/ecadev/Electra/src/Electra-qt /root/Electra-qt

RUN /bin/bash -c 'apt-get update; apt-get install -y $(cat /root/libs | tr -s "\n" " ")'

ENTRYPOINT ["/root/Electra-qt"]
