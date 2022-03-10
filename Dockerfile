FROM ubuntu:20.04

EXPOSE 7777 27016

RUN apt-get update && \
    apt-get install --no-install-recommends --no-install-suggests -y git git-lfs wget ca-certificates lib32gcc1

RUN mkdir -p /data/steamcmd

RUN mkdir /data/steamsdk

ADD run.sh /data/run.sh

RUN chmod +x /data/run.sh

RUN adduser --disabled-password --gecos '' -u 1200 app

RUN chown -R app:app /data

USER app

WORKDIR /data/steamcmd

RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

RUN ./steamcmd.sh +force_install_dir /data/steamsdk +login anonymous +app_update 1007 +quit

RUN mkdir -p /home/app/.steam/sdk64

RUN cp /data/steamsdk/linux64/steamclient.so /home/app/.steam/sdk64/

WORKDIR /data

ENV HOME /home/app

ENTRYPOINT ["./run.sh"]
