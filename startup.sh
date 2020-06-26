sudo apt-get update
sudo apt install -yq apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
sudo apt install -yq docker-ce

sudo docker ps
ls -l  /home/ubuntu

sudo docker run -dt --name ss -p ${SS_PORT}:${SS_PORT} mritd/shadowsocks -s "-s 0.0.0.0 -p ${SS_PORT} -m aes-256-cfb -k ${SS_PASSWD} --fast-open"

