export https_proxy="http://www-cache.gwdg.de:3128/"
export http_proxy="http://www-cache.gwdg.de:3128/"

module load git/2.31.1

rm -rf /tmp/build_singularity
mkdir /tmp/build_singularity
cd /tmp/build_singularity

# Install basic tools for compiling
sudo yum groupinstall -y 'Development Tools'
# Install RPM packages for dependencies
sudo yum install -y \
    libseccomp-devel \
    glib2-devel \
    squashfs-tools \
    cryptsetup \
    runc \
    git \
    wget

export VERSION=1.20.5 OS=linux ARCH=amd64  # change this as you need

wget -O /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz \
      https://dl.google.com/go/go${VERSION}.${OS}-${ARCH}.tar.gz
sudo tar -C /usr/local -xzf /tmp/go${VERSION}.${OS}-${ARCH}.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
