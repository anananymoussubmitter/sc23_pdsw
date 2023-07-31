BUILD_TO=/scratch-emmy/usr/gzadmhno/sc/Python

export https_proxy=
export http_proxy=

# build deps
yum install openssl-devel libffi-devel bzip2-devel libsqlite3x-devel


export https_proxy="http://www-cache.gwdg.de:3128/"
export http_proxy="http://www-cache.gwdg.de:3128/"

rm -rf /tmp/build_python
mkdir /tmp/build_python
cd /tmp/build_python
wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz

tar xvf Python-*.tgz
cd Python-3.9*/
./configure --enable-optimizations --prefix=${BUILD_TO}
make altinstall
