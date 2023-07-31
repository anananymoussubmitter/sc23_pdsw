PATH_TO_BENCHMARKS="/scratch-emmy/usr/anon/sc/new_benchmarks/rally-tracks-throughput"
PATH_TO_ESRALLY="/scratch-emmy/usr/anon/sc/Python/bin/esrally"

# just for saving path
enc_type="luks"
# just for saving path
RESULT_FOLDER="results1node"

# Functions
is_running() {
    while true; do
        read -p "Is an Elasticsearch already running on ${ES_HOSTS} (yes/no)? " answer
        case ${answer} in
            [Yy]* )
                echo "Starting the benchmarks..."
                break;;
            [Nn]* )
                echo "Please start the ES first..."
                exit;;
            * )
                echo "Please answer yes or no.";;
        esac
    done
}
save_race_data() {
  local benchmark_type="$1"
  local encryption_type="$2"
  local benchmark_size="$3"

  local path="./${RESULT_FOLDER}/${benchmark_type}/${encryption_type}/${benchmark_size}"
  mkdir -p "${path}"
  mv ~/.rally/benchmarks/races/* "${path}/"
}

# Prepare runs
is_running
#benchmark_types=("geonames" "nyc_taxis" "mrirally")
percentages=("10" "100")
#percentages=("100")
benchmark_types=("nyc_taxis" "mrirally")
#benchmark_types=("mrirally")

# The actual runs
for btype in "${benchmark_types[@]}"; do
  for p in "${percentages[@]}"; do
    echo "this happens"
    
    # debug just for us
    echo "$btype $p%"

    # save further metadata to collect after race
    echo $(date) > ~/.rally/benchmarks/races/before.txt
    echo $(hostname) > ~/.rally/benchmarks/races/hostname.txt
    echo $ES_HOSTS > ~/.rally/benchmarks/races/eshosts.txt
    echo $LOAD_DRIVER_HOSTS > ~/.rally/benchmarks/races/eshosts.txt

    # do the race
    ${PATH_TO_ESRALLY} race  --offline --track-path="${PATH_TO_BENCHMARKS}/${btype}" --pipeline=benchmark-only --target-hosts=127.0.0.1:9200 --track-params="ingest_percentage:${p}"

    # save further metadata to collect after race
    echo $(date) > ~/.rally/benchmarks/races/after.txt

    # collect metadata, write to this directory
    save_race_data "${btype}" "${enc_type}" "${p}"

    # they sometimes kill off each other
    sleep 5
  done
done
