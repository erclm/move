#! /bin/bash

# script by eric lim
# ver. 1.3

### $1 = from host
### $2 = to host
### $3 = oldid
### $4 = newid

## new nodes denoted as d2~d4
## ssh, zip, exit, scp, scp, ssh, unzip, chown -R, chmod -R, exit
## usage: ./move.sh oldPanelID newNodeName oldServerID newServerID
## usage example: ./move.sh 103 d2 1034 4

echo "*** moving server$3 from mc$1 to server$4 at $2.ggn.io"
echo "** continue? [y/n]"
read ans
if [ "$ans" = "y" ]
then
  echo "*** continuing"
else
  echo "*** exiting"
  exit 1
fi

echo "*** connecting to mc$1.ggservers.com.."
## zip
ssh root@mc$1.ggservers.com /bin/bash << EOF
  cd /home/minecraft/multicraft/servers/
  rm -rf server$3/*.zip
  rm -rf server$3/*.log
  rm -rf server$3/logs
  rm -rf server$3/crash-reports
  mv server$3 moving
  zip -r moving.zip moving
  mv moving server$3
EOF

echo "*** copying zip to new node.."
scp -r root@mc$1.ggservers.com:/home/minecraft/multicraft/servers/moving.zip ~/move/moving.zip
scp -r ~/move/moving.zip root@$2.ggn.io:/home/minecraft/multicraft/servers/moving.zip

echo "*** applying changes to new node.."
ssh root@$2.ggn.io /bin/bash << EOF
  cd /home/minecraft/multicraft/servers
  rm -rf server$4
  unzip moving.zip
  mv moving server$4
  chown -R mc$4:mc$4 server$4
  rm -rf moving.zip
  ls server$4
EOF
echo "*** done migrating."
echo "*** removing old files.."
ssh root@mc$1.ggservers.com /bin/bash << EOF
  cd /home/minecraft/multicraft/servers/
  rm -rf moving.zip
EOF

rm -rf moving.zip

echo "*** operation complete"
exit 0
