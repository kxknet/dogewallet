sudo apt update -y
sudo apt install -u apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update -y
apt-cache policy docker-ce
sudo apt install -y docker-ce
cd ~/
wget https://github.com/Joystream/joystream/releases/download/v7.5.0/joystream-node-3.3.0-fdb75f5ec-x86_64-linux-gnu.tar.gz
tar -vxf joystream-node-3.3.0-fdb75f5ec-x86_64-linux-gnu.tar.gz
wget https://github.com/Joystream/joystream/releases/download/v7.5.0/joy-testnet-4.json
./joystream-node --chain joy-testnet-4.json --pruning archive --validator
