cd /scratch-emmy/usr/gzadmhno/sc

# If there is no singularity folder in here, run the `./build_singularity.sh` instead
#./install_deps_only_singularity.sh
./build_singularity.sh

# nest, make the ES user required for the container
./make_elasticsearch_user.sh

# next, build the encryption container wanted
# Check with `mount` whether it worked
./create_luks.sh
./create_gocryptfs.sh

# next, do secondary preperations
./other_prep_stuff.sh

# if not existing...
./build_python.sh

echo "ready" > /dev/shm/ready

echo "Now start working from /local/new_benchmarks !"
