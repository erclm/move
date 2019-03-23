#! /bin/bash

### $1 = from host
### $2 = to host
### $3 = oldid
### $4 = newid

## new nodes denoted as d2~d4
## ssh, zip, exit, scp, scp, ssh, unzip, chown -R, chmod -R, exit
## usage: ./move.sh oldPanelID newNodeName oldServerID newServerID
## usage example: ./move.sh 103 d2 1034 4

echo "connecting to mc$1.ggservers.com.."
## zip
ssh root@mc$1.ggservers.com /bin/bash << EOF
  cd /home/minecraft/multicraft/servers/
  ls server$3
  zip -r server$4.zip server$3
EOF

scp -r root@mc$1.ggservers.com:/home/minecraft/multicraft/servers/server$4.zip root@$2.ggn.io:/home/minecraft/multicraft/servers/
