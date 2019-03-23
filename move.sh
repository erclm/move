#! /bin/bash

### $1 = from host
### $2 = to host
### $3 = oldid
### $4 = newid

## new nodes denoted as d2~d4
## ssh, zip, exit, scp, scp, ssh, unzip, chown -R, chmod -R, exit

## Testing remote
echo "connecting to mc$1.ggservers.com.."
ssh root@mc$1.ggservers.com /bin/bash << EOF
        ls;
	pwd
EOF
