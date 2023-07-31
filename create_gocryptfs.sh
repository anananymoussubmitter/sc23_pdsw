# Expects the mount folder to already be there
#PATH_TO_BASE_PATH=/scratch1/users/lars.quentin01/gocrypt
PATH_TO_BASE_PATH=/scratch-emmy/usr/gzadmhno/sc/gocrypt

mkdir -p /create_gocryptfs
cd /create_gocryptfs

#cd /scratch/usr/gzadmhno/gocryptbase

chmod u+s $(which fusermount)
# on emmy there is a second one that is actually used lol
chmod u+s /bin/fusermount
chmod u+s /bin/fusermount3

mkdir -p /data/gocryptfs
umount /data/gocryptfs
mkdir -p /data/gocryptfs
chown -R elasticsearch:elasticsearch /data/gocryptfs

# allow other
sudo sed -i '/^[[:space:]]*#[[:space:]]*user_allow_other$/s/^#//' /etc/fuse.conf

# Build gocryptfs
rm -rf /usr/local/go
export http_proxy=http://www-cache.gwdg.de:3128
export https_proxy=http://www-cache.gwdg.de:3128
git clone https://github.com/rfjakob/gocryptfs.git

export VERSION=1.20.5
OS=linux ARCH=amd64
wget https://dl.google.com/go/go$VERSION.$OS-$ARCH.tar.gz
tar -C /usr/local -xzvf go$VERSION.$OS-$ARCH.tar.gz
yes | rm go$VERSION.$OS-$ARCH.tar.gz

echo 'export GOPATH=${HOME}/go' >> ~/.bashrc
echo 'export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin' >> ~/.bashrc
source ~/.bashrc

cd gocryptfs
./build-without-openssl.bash
echo "test" > gcfspw
chmod 777 gcfspw
sudo -u elasticsearch ./gocryptfs -passfile gcfspw -allow_other $PATH_TO_BASE_PATH /data/gocryptfs
