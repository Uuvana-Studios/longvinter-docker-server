FROM alpine:3.15.2

# Install necessary linux packages
RUN apk update && apk add --arch x86 --no-cache --virtual build-deps git git-lfs wget ca-certificates tar libgcc bash 

# Steam user variables  
ENV UID 1000
ENV USER steam
ENV HOME /home/$USER

# Create the steam user and data directory
RUN adduser --disabled-password --gecos '' -u $UID $USER && \
    mkdir -p /data && dpkg --add-architecture i386

# Copy all necessary scripts
WORKDIR $HOME
COPY run.sh .

# Set scripts as executable and set ownership of home/data directories
RUN chmod +x run.sh && \
    chown -R $USER:$USER /home/$USER && \
    chown -R $USER:$USER /data

# Install the SteamCMD as the steam user
USER steam
WORKDIR $HOME
RUN mkdir -p steamcmd && cd steamcmd && \
    wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && \
    tar -xvzf steamcmd_linux.tar.gz && \
    rm steamcmd_linux.tar.gz

# Install the Steam SDK
WORKDIR $HOME/steamcmd
RUN ./steamcmd.sh +force_install_dir . +login anonymous +app_update 1007 +quit

# Link 64-bit binaries (this may not even be necessary?)
RUN mkdir -p $HOME/.steam/sdk64 && \
    ln -s $HOME/steamcmd/linux64/steamclient.so $HOME/.steam/sdk64/

WORKDIR $HOME
EXPOSE 7777 27016

ENTRYPOINT ["/bin/sh"]
CMD ["./run.sh"]
