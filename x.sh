#!/bin/bash
apt-get update
apt install curl git gpw ufw -y
ufw allow 80/tcp && ufw allow 12345/udp	#Open ports
curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
source /root/.cargo/env
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
apt install nodejs -y
npm install -g yarn
yarn set version latest
git clone https://github.com/radicle-dev/radicle-bins.git
cd /root/radicle-bins/
git reset --hard f1462b92a06ef65ec4b65201e9801473a41b4ee3
apt install build-essential -y
cd /root/radicle-bins/seed/ui && yarn && yarn build
mkdir -p ~/.radicle-seed
cargo run -p radicle-keyutil -- --filename ~/.radicle-seed/secret.key
#extip="$(echo -e $(hostname -I) | sed -e 's/[[:space:]]*$//')"	#if several ip, then an error. Comment 22.02.2021
extip=$(hostname -I)
extip=${extip%% *}	#delete all symbol after space
namelen="$(( $RANDOM % 5 + 6 ))"
name="$(gpw 1 $namelen)"
echo "#!/usr/bin/bash
source $HOME/.cargo/env
cd ~/radicle-bins
cargo run -p radicle-seed-node --release -- \
  --root ~/.radicle-seed \
  --peer-listen 0.0.0.0:12345 \
  --http-listen 0.0.0.0:80 \
  --name "$name" \
  --public-addr "$extip"":12345" \
  --assets-path seed/ui/public \
  < ~/.radicle-seed/secret.key"  > /root/autostartradicle.sh
chmod 777 /root/autostartradicle.sh
npm install pm2 -g
sudo pm2 startup -u root
sudo pm2 install pm2-logrotate
sudo pm2 set pm2-logrotate:max_size 50M
cd /root
sudo pm2 start ~/autostartradicle.sh --name=radicle
sudo pm2 save 
