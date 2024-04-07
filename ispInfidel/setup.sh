#!/bin/bash
echo "------ SETTING UP THE ISP INFIDEL ------"
if [[ ! -d networkFlaskApp ]]; then
    echo " !!! Cannot find src folder, please fix and try again!"
    exit 1
fi

echo "### CREATING DEST DIR ###"
sudo mkdir -p /var/ispInfidel/
sudo cp -r networkFlaskApp /var/ispInfidel
sudo chown -R $USER:$USER /var/ispInfidel
cd /var/ispInfidel/networkFlaskApp/


echo "### INSTALLING PY REQS ###"
python3 -m pip install -r requirements.txt --break-system-packages

echo "### INSTALLING SERVICE FILES ###"
if [[ ! -d /etc/systemd/system/ ]]; then
    echo "No /etc/systemd/system/ dir found!"
    exit 1
fi

if [[ ! -f /etc/systemd/system/nannyApp.service ]]; then 
    sudo ln -s /var/ispInfidel/networkFlaskApp/nannyApp.service /etc/systemd/system/
fi

if [[ ! -f /etc/systemd/system/nannyAnnoy.service ]]; then 
    sudo ln -s /var/ispInfidel/networkFlaskApp/nannyAnnoy.service /etc/systemd/system/
fi

if [[ ! -f /etc/systemd/system/nannyNetwork.service ]]; then 
    sudo ln -s /var/ispInfidel/networkFlaskApp/nannyNetwork.service /etc/systemd/system/
fi

echo "### STARTING SERVICES! ###"
sudo systemctl daemon-reload
sudo systemctl start  nannyApp.service nannyNetwork.service nannyAnnoy.service
sudo systemctl enable nannyApp.service nannyNetwork.service nannyAnnoy.service

statusStr="sudo systemctl status nannyApp.service nannyNetwork.service nannyAnnoy.service"
echo -e "Check the status of services with:\n\t${statusStr}"
echo -e "\n\n"
echo -e "Visit 'localhost:9090' to view metrics" 
echo "------ SUCCESSFULLY INSTALLED ISP INFIDEL! ------"
