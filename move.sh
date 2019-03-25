#! /bin/bash

# script by eric lim
# ver. 1.1

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
  echo "* cleaning up server$3.."
  rm -rf server$3/*.zip
  rm -rf server$3/*.log
  rm -rf server$3/logs
  rm -rf server$3/crash-reports
  ls server$3
  echo "* zipping.."
  zip -r server$3.zip server$3
EOF

echo "*** copying zip to new node.."
scp -r root@mc$1.ggservers.com:/home/minecraft/multicraft/servers/server$3.zip ~/server$4.zip
scp -r ~/server$4.zip root@$2.ggn.io:/home/minecraft/multicraft/servers/server$4.zip

echo "*** applying changes to new node.."
ssh root@$2.ggn.io /bin/bash << EOF
  cd /home/minecraft/multicraft/servers
  rm -rf server$4
  echo "* unzipping.."
  unzip server$4.zip
  echo "* setting permissions.."
  chown -R mc$4:mc$4 server$4
  chmod -R 700 server$4
  echo "* cleaning up.."
  rm -rf server$4.zip
  ls server$4
EOF

echo "*** removing old files.."
ssh root@mc$1.ggservers.com /bin/bash << EOF
  cd /home/minecraft/multicraft/servers/
  rm -rf server$3.zip
EOF

rm -rf server$4.zip

echo "*** operation complete"
exit 0
