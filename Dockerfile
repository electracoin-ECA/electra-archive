FROM electracoin/electra-builder:0.1 as builder

COPY --chown=ecadev ./ /home/ecadev/Electra

WORKDIR /home/ecadev/Electra

RUN qmake GUI=0; make

FROM electracoin/electra-runner:0.1

COPY --from=builder /home/ecadev/Electra/src/Electra-qt /root/Electra-qt

ENTRYPOINT ["/root/Electra-qt", "-daemon=0"]
