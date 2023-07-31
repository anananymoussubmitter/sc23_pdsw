# dfa008 (coordinator + load driver)
esrallyd start --node-ip=10.108.97.108 --coordinator-ip=10.108.97.108

# dfa009 (load driver)
esrallyd start --node-ip=10.108.97.109 --coordinator-ip=10.108.97.108

# dfa010 (load driver)
esrallyd start --node-ip=10.108.97.110 --coordinator-ip=10.108.97.108


# estest-4 start run
time esrally race --test-mode --pipeline=benchmark-only --track=geonames --target-hosts=10.254.1.5:9200,10.254.1.9:9200,10.254.1.8:9200 --load-driver-hosts=10.254.1.22,10.254.1.25,10.254.1.10

# teardown on each machine
esrallyd stop
