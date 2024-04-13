#!/bin/bash

## GLOBALS 
# File paths for source and destination
destDir="/var/ispInfidel/"
srcDir="networkFlaskApp/"
# Shell args 
BREAK_SYS=0

## METHODS
# Method to install service files to systemd
installServiceFile() 
{
    # If the service file already exists, remove it
    if [[ -f /etc/systemd/system/${1} ]]; then 
        sudo rm /etc/systemd/system/${1}
    fi
    
    # Soft link the service file from destination directory to systemd
    sudo ln -s /var/ispInfidel/networkFlaskApp/${1} /etc/systemd/system/
}

helpMenu()
{
    echo -e "Usage:\n\t./setup.sh [ -b ]\n\t-b\tInstalls Py reqs with --break-system-requirements"
    exit 0
}

## ARGUMENTS
# Capture and process arguments passed with script
while getopts 'bh' OPTION; do
    case "$OPTION" in
        # If the user has passed the -b flag, set BREAK_SYS
        b)
            BREAK_SYS=1
        ;;
        # Help menu
        h)
            helpMenu
        ;;
    esac 
done

## MAIN
echo "------ SETTING UP THE ISP INFIDEL ------"
if [[ ! -d ${srcDir} ]]; then
    echo " !!! Cannot find src folder, please fix and try again!"
    exit 1
fi

echo "### CREATING DEST DIR ${destDir} ###"
if [[ -d  ${destDir} ]]; then
    echo " !!! Removing current ${destDir} "
    sudo rm -rf ${destDir}
fi
# Creating dir
sudo mkdir -p ${destDir}

# Copying source to dest 
sudo cp -r ${srcDir} ${destDir}

# Changing permissions so user running this scripts owns the dest dir
sudo chown -R ${USER}:${USER} ${destDir}

# Enter the dest dir
cd ${destDir}${srcDir}

# If the user chose to install with breaking system reqs, do so
if [[ ${BREAK_SYS} -eq 1 ]]; then
    echo "### INSTALLING PY REQS (w/ --break-system-packages) ###"
    python3 -m pip install -r requirements.txt --break-system-packages
else
    echo "### INSTALLING PY REQS ###"
    python3 -m pip install -r requirements.txt
fi

echo "### INSTALLING SERVICE FILES ###"
if [[ ! -d /etc/systemd/system/ ]]; then
    echo "No /etc/systemd/system/ dir found!"
    exit 1
fi

# Install the service files for the ispInfidel
installServiceFile nannyApp.service
installServiceFile nannyAnnoy.service
installServiceFile nannyNetwork.service

echo "### STARTING SERVICES! ###"
sudo systemctl daemon-reload
sudo systemctl stop  nannyApp.service nannyNetwork.service nannyAnnoy.service
sudo systemctl start  nannyApp.service nannyNetwork.service nannyAnnoy.service
sudo systemctl enable nannyApp.service nannyNetwork.service nannyAnnoy.service

statusStr="sudo systemctl status nannyApp.service nannyNetwork.service nannyAnnoy.service"
echo -e "\n"
echo -e "Check the status of services with:\n\t${statusStr}"
echo -e "Replace 'status' with 'restart', 'stop' and 'start' to perform relative functions"
echo -e "\n"
echo -e "Visit 'localhost:9090' to view metrics" 
echo "------ SUCCESSFULLY INSTALLED ISP INFIDEL! ------"
