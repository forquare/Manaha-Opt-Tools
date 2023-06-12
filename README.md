# THIS REPO IS DEPLRECATED

From June 2023, Manaha now runs not with a series of shell and Perl scripts, but with a monolithic Go application: Manaha Minder.

You can find Manaha Minder over in its repo: https://github.com/forquare/Manaha-Minder

---

# Manaha-Opt-Tools


Repo for all tools on the Manaha server

One should be able to simply clone this repo into the desired location—I place it in `~/opt` of my Minecraft administrator:

    cd ~
    mkdir opt
    cd opt
    git clone https://github.com/forquare/Manaha-Opt-Tools.git

The scripts currently load in a number of varibales from a file.  If you are deploying these tools, you’ll currently need to edit most of the scripts (maybe all) to point to your config file.  **My** config file is located at `/home/manaha-minecrafter/configs/common_variables.conf`.  It needs to contain values for all of the following:

    MSM=
    SERVER=
    BIN_DIR=
    CONFIG_DIR=
    MAP_CONFIG_FILE=
    MAINTENANCE_LOGS_DIR=
    OPT_DIR=
    VAR_DIR=
    LOCK_DIR=
    ACTIVITY_LOG=
    ACTIVITY_OUTPUT=
    PLAYERS=
    PLAYERS_HTML=
    SERVER_LOGS=
    SERVER_DIR=
    SERVER_LOGS_DIR=
    SERVER_WORLD_DIR=
    OPERATOR_CONFIG=
    HTTP_MAP=
    HTTP=
    PERL=
    WELCOME_MESSAGE=
    
Below is an example:

    MSM=/usr/local/bin/msm
    SERVER=manaha
    BIN_DIR=/home/manaha-minecrafter/opt/bin
    CONFIG_DIR=/home/manaha-minecrafter/configs
    MAP_CONFIG_FILE=/home/manaha-minecrafter/configs/manaha_map_config.conf
    MAINTENANCE_LOGS_DIR=/home/manaha-minecrafter/maintenance_logs
    OPT_DIR=/home/manaha-minecrafter/opt
    VAR_DIR=/home/manaha-minecrafter/var
    LOCK_DIR=/home/manaha-minecrafter/var/lock
    ACTIVITY_LOG=/home/manaha-minecrafter/opt/activity/activity.txt
    ACTIVITY_OUTPUT=/srv/web/mc/public_html/activity.txt
    PLAYERS=/home/manaha-minecrafter/opt/players.txt
    PLAYERS_HTML=/srv/web/mc/public_html/players.html
    SERVER_LOGS=/opt/msm/servers/manaha/logs/latest.log
    SERVER_DIR=/opt/msm/servers/manaha
    SERVER_LOGS_DIR=/opt/msm/servers/manaha/logs
    SERVER_WORLD_DIR=/opt/msm/servers/manaha/world
    OPERATOR_CONFIG=/home/manaha-minecrafter/configs/operators.txt
    HTTP_MAP=/srv/web/mc/public_html/EXTRAS/map
    HTTP=/srv/web/mc/public_html/EXTRAS
    PERL=/usr/bin/perl
    WELCOME_MESSAGE="Welcome"
