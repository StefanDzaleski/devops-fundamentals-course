#!/bin/bash

CLIENT_HOST_DIR=$(pwd)/../../shop-angular-cloudfront
CLIENT_NGINX_CONF=$(pwd)/lab3_client.conf

# destination folder names can be changed
CLIENT_REMOTE_DIR=/var/www/lab3_client
CLIENT_REMOTE_CONF=/etc/nginx/conf.d

check_remote_dir_exists() {
  echo "Check if remote directories exist"

  if ssh rhhost "[ ! -d $1 ]"; then
    echo "Creating: $1"
	ssh -t rhhost "sudo bash -c 'mkdir -p $1 && chown -R sshuser: $1'"
  else
    echo "Clearing: $1"
    ssh rhhost "sudo -S rm -r $1/*"
  fi
}

check_remote_dir_exists $CLIENT_REMOTE_DIR

echo "---> Building and transfering client files, cert and ngingx config - START <---"
echo $CLIENT_HOST_DIR
cd $CLIENT_HOST_DIR && npm run build && cd ../
scp -Cr $CLIENT_HOST_DIR/build/* rhhost:$CLIENT_REMOTE_DIR
sudo scp -Cr $CLIENT_NGINX_CONF rhhost:$CLIENT_REMOTE_CONF
echo "---> Building and transfering - COMPLETE <---"

echo "---> Starting nginx and backend app on server - START <---"
ssh rhhost  "systemctl start nginx"
ssh rhhost "cd $SERVER_REMOTE_DIR && npm i && pm2 start index.js"
echo "---> Services have been started <---"

# ssl certificates
