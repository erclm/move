# move
server transfer script for ggservers


## usage: ./move.sh oldPanelID newNodeName oldServerID newServerID
operations: ssh, zip, exit, scp, scp, ssh, unzip, chown -R, chmod -R, exit
### usage example: ./move.sh 103 d2 1034 4

## UPDATE:
### 1.1
- now keeps old files, fixed authentication issues
### 1.2
- renamed zipped file
### 1.3
- no chmod
