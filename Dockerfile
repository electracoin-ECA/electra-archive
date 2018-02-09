FROM electracoin/electra:latest as builder

USER ecadev

COPY --chown=ecadev ./ /home/ecadev/Electra

WORKDIR /home/ecadev/Electra

RUN qmake GUI=0; make

RUN objdump -p /home/ecadev/Electra/src/Electra-qt | grep NEEDED | awk '{ print $2 }' | xargs dpkg -S | cut -d':' -f 1 > /home/ecadev/Electra/libs

FROM ubuntu:xenial

COPY --from=builder /home/ecadev/Electra/libs /root/libs
COPY --from=builder /home/ecadev/Electra/Electra.conf /root/.Electra/Electra.conf
COPY --from=builder /home/ecadev/Electra/src/Electra-qt /root/Electra-qt

RUN /bin/bash -c 'apt-get update; apt-get install -y $(cat /root/libs | tr -s "\n" " "); rm -rf /var/lib/apt/lists/*; rm /root/libs'

ENTRYPOINT ["/root/Electra-qt"]
