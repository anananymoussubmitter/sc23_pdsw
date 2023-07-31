groupadd -g 1000 elasticsearch && sudo useradd -u 1000 -g 1000 -d /usr/share/elasticsearch -s /bin/bash elasticsearch

mkdir -p /data/{esluks,gocryptfs}
chown -R elasticsearch:elasticsearch /data
