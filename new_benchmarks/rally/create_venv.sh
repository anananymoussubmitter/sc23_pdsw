export https_proxy="https://www-cache.gwdg.de:3128/"
export http_proxy="http://www-cache.gwdg.de:3128/"
module load python/3.9.0
module load git/2.31.1

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Now we have to create all local data
esrally list tracks # get all tracks

# I do not know whether it will also work without an ES running
# The expected result is that ~/.rally/ contains the .json.bz2 corpora
esrally race --test-mode --track=geonames --pipeline=benchmark-only --target-hosts=127.0.0.1:9200
esrally race --test-mode --track=nyc_taxis --pipeline=benchmark-only --target-hosts=127.0.0.1:9200

mv ~/.rally ./rally
# TODO change accordingly
ln -s /local/new_benchmarks/rally/rally /root/.rally
rm -rf ~/.rally/benchmarks/races/* # those were the dummies above
