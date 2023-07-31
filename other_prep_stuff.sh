# copy data to /local
# not existing on emmy
#cp -rv ./new_benchmarks /local/
#chown -R elasticsearch:elasticsearch /local/new_benchmarks

# move the data to /dev/shm
# we also dont have space for that one on emmy
#cp -rv ./new_benchmarks/rally-tracks-throughput /dev/shm/

# Do the root linking
# (in our case, the partition containing /root is too small, so we also put it onto /dev/shm)
rm -rf /root/.rally
cp -rv ./new_benchmarks/rally/rally /dev/shm/
ln -s /dev/shm/rally /root/.rally
