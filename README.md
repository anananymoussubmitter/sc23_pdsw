# Deploying and Benchmarking Secure Elasticsearch Clusters on HPC Systems for Sensitive Data - Data

This is the structure used for all the benchmarking.
Also, this document contains the instructions for the most important operations, such as setting up a new node as well as performing an distributed elasticsearch benchmark with different encryption methods and data corpora.

Nested in each folder will be another README with more information about the data contained in that folder.

## Overview of current folder

The current folder is the root folder.

- `prep_everything.sh` is the main script to set up a new node for benchmarking. It assumes a CentOS Linux 7. This calls all other `.sh` scripts in this root folder.
- `gocrypt/luks/plain` are used as data storage for benchmarking mounted in singularity
- `new_benchmarks` contains the actual benchmark logic, see the folders README for further information.

## How to set up a new node for benchmarking

This setup is developed for CentOS 7.

See the contents of `./prep_everything.sh`.

## How to encrypt a JSON corpus

Our encryption library can be found in `./new_benchmarks/rally-tracks-throughput/encryption`. It can be used to encrypt rally corpora for use in benchmarking. A rally corpus is a file with one json object a line, with those having a previously defined structure given as an `index.json`

See `./new_benchmarks/rally-tracks-throughput/encryption/README.md` for an guide and explaination.


## How to perform a Rally Benchmark

Given that the nodes are properly set up and the rally track is prepared under `./new_benchmarks/rally-tracks-throughput` the benchmark can be started using the following steps:

0. Set up all nodes, see above. Make sure that no ES and rally instances are currently running.
1. Create the cluster configs: Enter your cluster IPs and hostnames into the config generation script, use `./new_benchmarks/multi_node/create_configs/create_es_config31.py` as a basis. After verified that they look good, move the configs to `./new_benchmarks/multi_node/hpc-configs/`. Make sure they are owned by uid 1000 gid 1000 as this is the container internal uid of elasticsearch, which will read and write in that folder.
2. Prepare the esrally starter script: All load generator need to use the same coordinator node, so write that IP into `/new_benchmarks/multi_node/start_esrallyd.sh`.
3. Start the load generators by running the `start_esrallyd` script on every node. Start using the coordinator node.
4. Start the ES cluster, using one of the `./sc/new_benchmarks/multi_node/start_*.sh` scripts. Change the data path accordingly to where the data storage should be bind-mounted from. Depending on this choice, you will use a different encryption method!
5. Adapt the benchmarking script: See the `./new_benchmarks/rally/run_multi_node*.sh` scripts. Choose one as a basis, wlog `run_multi_node31.sh`. Change the `ES_HOSTS` to your IPs you decided on, don't forget to write the ports. Write all `LOAD_DRIVER_HOSTS`, don't specify any ports. The `enc_type` and `RESULT_FOLDER` change the results saving path but do not change the benchmarks. Change the `PATH_*` variables to your paths. Lastly, change the `benchmark_types` and `percentages` arrays to the benchmarks of interest. The `benchmark_type` names have to match the folder names in `./sc/new_benchmarks/rally-tracks-throughput`, see that README for more information.
6. Start the script.

Pro tip: If you want to make sure that your cluster is healthy enough to start, query it with `${HOST}:9200/_cluster/health?pretty`.

## How to perform a cURL Benchmark

1. Also setup and start the ES cluster as described in the previous section
2. Use one of the `./sc/new_benchmarks/rally/ingest*` scripts, change the corpora and hosts accordingly. See above for a deeper explaination.
3. Change the `HOSTNAMES_LIST` variable of the benchmark of interest located in `./queries`
4. Start the matching `outer_loop*` script with the starting time in `HH:MM:SS` on all nodes that should generate the load

## How to generate fake MRI data

The data generator can be found at `./new_benchmarks/rally-tracks-throughput/mrirally/generate_json.py`. The code is well doucmented and self explainatory.
If the data should be used for the rally benchmark, its recommended to use the `generate_json.sh` wrapper instead because it also changes [the track information such as corpus size or byte amount](https://esrally.readthedocs.io/en/stable/adding_tracks.html).

## How to re-analyze the results

Run the python scripts found in `./sc-results`
