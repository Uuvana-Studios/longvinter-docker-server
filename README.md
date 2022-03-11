# longvinter-docker-server
Docker config for setting up a Longvinter server

## System requirements
This Docker container runs on any OS that supports Docker, provided it has an Intel or AMD processor. Docker for ARM or Apple Silicon does not work since SteamCMD does not appear to support these platforms. Also make sure the requirements described in the official server repo are met as well: https://github.com/Uuvana-Studios/longvinter-linux-server. Note that you do not have to install anything other than Docker and Docker Compose on the system that will run this container. However, it is recommended to use Git to download and update the configuration in this Github repository.

Note: Using this Docker container setup requires knowledge about how Docker works. Basic knowledge of the command line may also be required.

## Install Docker

### Windows
Download Docker Desktop by clicking the button on this page:
https://docs.docker.com/desktop/windows/install/

Docker Desktop comes bundled with Docker Compose, so no additional actions are required for a Windows installation.

### Ubuntu
For installation instructions for Docker on Ubuntu, visit this page:
https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository

Also install Docker Compose (click the Linux tab for the correct instructions):
https://docs.docker.com/compose/install/

## Setting up the container

### Downloading the container
Downloading the container can be done by either using git (recommended), or by clicking the green Code button on this page and using the Download ZIP option.

To download the container configuration using git, use the command below:

```shell
git clone https://github.com/tvandoorn/longvinter-docker-server.git
```

### Creating the data directory
In order to keep game progress between container restarts a `data` directory needs to be created. Create this directory in the same directory as the `docker-compose.yaml` file.

When using Ubuntu, use the following commands to create the directory and set the appropriate rights.
```shell
mkdir data
chown -R 1200:1200 data/
```

### Configuring the server settings
The server settings can be changed by opening the `docker-compose.yaml` file. Settings that may be changed are shown below:

| Setting name          | Used for                                                                                                                                                                                                                                       | Default value                 |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------|
| CFG_SERVER_NAME       | Setting the server name that is displayed in the server list.                                                                                                                                                                                  | Unnamed Island                |
| CFG_MAX_PLAYERS       | The maximum amount of players the server will allow at the same time.                                                                                                                                                                          | 32                            |
| CFG_SERVER_MOTD       | A Message Of The Day that will be displayed to the player.                                                                                                                                                                                     | Welcome to Longvinter Island! |
| CFG_PASSWORD          | Use this setting to require a password to join the server.                                                                                                                                                                                     | _(empty)_                     |
| CFG_COMMUNITY_WEBSITE | When the server or community has a website, enter it here to display it to the player.                                                                                                                                                         | www.longvinter.com            |
| CFG_ADMIN_STEAM_ID    | Add the SteamID64 values for the players that have admin rights to this setting. When there are multiple admins, add the SteamID64 values to this setting separated by a space.                                                                | _(empty)_                     |
| CFG_ENABLE_PVP        | When this setting is set to "true", PvP will be enabled on the server. Set to "false" to disable PvP.                                                                                                                                          | true                          |
| CFG_GAME_PORT         | This setting is used to change the game port when multiple servers are running on the same (public) IP address. When changing this setting, make sure to also change the port number under the ports section of the docker-compose.yaml file.  | 7777                          |
| CFG_QUERY_PORT        | This setting is used to change the query port when multiple servers are running on the same (public) IP address. When changing this setting, make sure to also change the port number under the ports section of the docker-compose.yaml file. | 27016                         |

With the default values above, the environment part of the `docker-compose.yaml` file should look like this:
```shell
environment:
  CFG_SERVER_NAME: "Unnamed Island"
  CFG_MAX_PLAYERS: "32"
  CFG_SERVER_MOTD: "Welcome to Longvinter Island!"
  CFG_PASSWORD: ""
  CFG_COMMUNITY_WEBSITE: "www.longvinter.com"
  CFG_ADMIN_STEAM_ID: ""
  CFG_ENABLE_PVP: "true"
  CFG_GAME_PORT: "7777"
  CFG_QUERY_PORT: "27016"
```

### Changing the port numbers
In order to run the server with different port numbers than the default ports `7777` and `27016`, the new port numbers have to be edited in two places in the `docker-compose.yaml` file. 
```shell
ports:
  - "7777:7777/tcp"
  - "7777:7777/udp"
  - "27016:27016/tcp"
  - "27016:27016/udp"
```

```
environment:
  CFG_GAME_PORT: "7777"
  CFG_QUERY_PORT: "27016"
```

## Starting the container
When the setup and configuration is done, the container is ready to be started. Open the command line and navigate to the directory (using the `cd` command) that contains the `Dockerfile`, `docker-compose.yaml` and `run.sh` files.

Start the container using the following command:
```shell
docker-compose up -d
```

This command will do the following:
1. Build the container image (if not present)
2. Create the container
3. Start the container
4. Run the included startup script (`run.sh`) inside the container
   1. Clone or update the longvinter-linux-server repository
   2. Create or update the Game.ini file with the settings provided in the `docker-compose.yaml` file
5. Start the Longvinter server

## Stopping the container
To stop the container, run the command below. Note that this removes the container from Docker, but the save data will be saved in the `data` directory and will be loaded when the server is started again next time.
```shell
docker-compose down
```

## Updating the container
When a new version of the container is released, make sure to update the files using `git pull`, or manually update the files by downloading the code as ZIP from Github. Run the command below to build the new container image and restart the container.
```shell
docker-compose up -d --build
```
Note that these commands have to be run from the same directory as the `Dockerfile`, `docker-compose.yaml` and `run.sh` files.

## Updating the Longvinter server
Updating the Longvinter server is as easy as restarting the container:
```shell
docker-compose restart
```

## Running multiple Longvinter containers on one Docker server
Running multiple Longvinter containers on one Docker server is very easy. Follow the _Setting up the container_ steps again, but this time set up the server to use a different directory for the new server.
```shell
git clone https://github.com/tvandoorn/longvinter-docker-server.git new-name-here
```
The command above will download the container files in a directory named `new-name-here`. Make sure to change the server ports using the _Changing the port numbers_ step.

## Portforwarding and firewalls
When running the container it might be necessary to do port forwarding or open ports in your firewall. For port forwarding instructions, please refer to the information/documentation provided by your ISP or router/modem manufacturer. For opening ports in your software firewall use the `Windows Firewall with Advanced Security` tool for Windows systems. For Linux based systems you can use the ufw or iptables tools. Please refer to their official documentation for instructions.

**Please do not create issues on Github for problems related to port forwarding or firewalls.**

# Disclaimer
THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
