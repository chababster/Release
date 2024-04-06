# Release Repo
Release repo meant to be accesible by any and everyone

## ISP Infidel
App designed to run on a low-profile, Linux-based for bugging your ISP and serving up a webpage for viewing historics

### Usage
- Enter the Network Nanny directory
```
cd ispInfidel
```

- Run the set up script with sudo to setup and start the services.
- This installs using --break-system-packages
```
sudo ./setup.sh
```

- Services are enabled to start on boot and run approximately every 5 minutes
- If you want to stop, start, restart or view the status of the services
```
# Replace 'stop' with 'restart' 'start' or 'status' 
sudo systemctl stop nannyApp.service nannyNetwork.service nannyAnnoy.service
```