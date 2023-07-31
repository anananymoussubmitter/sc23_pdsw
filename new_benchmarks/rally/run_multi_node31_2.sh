# ES_HOSTS have the format ${IP}:9200,
ES_HOSTS="10.241.132.17:9200,10.241.132.18:9200,10.241.132.19:9200,10.241.132.20:9200,10.241.132.21:9200,10.241.132.22:9200,10.241.132.23:9200,10.241.132.24:9200,10.241.132.25:9200,10.241.132.26:9200,10.241.132.27:9200,10.241.132.28:9200,10.241.132.29:9200,10.241.132.30:9200,10.241.132.31:9200,10.241.132.32:9200,10.241.132.33:9200,10.241.132.34:9200,10.241.132.35:9200,10.241.132.36:9200,10.241.132.37:9200,10.241.132.38:9200,10.241.132.39:9200,10.241.132.40:9200,10.241.132.41:9200,10.241.132.42:9200,10.241.132.43:9200,10.241.132.44:9200,10.241.132.45:9200,10.241.132.46:9200,10.241.132.47:9200"
# Load driver dont have ports
# IMPORTANT
# THE COORDINATOR HAS TO BE WRITTEN AS THE FIRST LOAD_DRIVER_HOST!!!
# OTHERWISE IT WILL FAIL WITH AN CRYPTIC MESSAGE
# IMPORTANT
LOAD_DRIVER_HOSTS="10.241.132.17,10.241.132.18,10.241.132.19,10.241.132.20,10.241.132.21,10.241.132.22,10.241.132.23,10.241.132.24,10.241.132.25,10.241.132.26,10.241.132.27,10.241.132.28,10.241.132.29,10.241.132.30,10.241.132.31,10.241.132.32,10.241.132.33,10.241.132.34,10.241.132.35,10.241.132.36,10.241.132.37,10.241.132.38,10.241.132.39,10.241.132.40,10.241.132.41,10.241.132.42,10.241.132.43,10.241.132.44,10.241.132.45,10.241.132.46,10.241.132.47"

PATH_TO_BENCHMARKS="/scratch-emmy/usr/anon/sc/new_benchmarks/rally-tracks-throughput"
PATH_TO_ESRALLY="/scratch-emmy/usr/anon/sc/Python/bin/esrally"

# just for saving path
enc_type="luks"
# just for saving path
RESULT_FOLDER="resulthno31lustre"

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
#benchmark_types=("nyc_taxis_encrypted")
benchmark_types=("mrirally")

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
    ${PATH_TO_ESRALLY} race  --offline --track-path="${PATH_TO_BENCHMARKS}/${btype}" --pipeline=benchmark-only --target-hosts=${ES_HOSTS} --load-driver-hosts=${LOAD_DRIVER_HOSTS} --track-params="ingest_percentage:${p}"

    # save further metadata to collect after race
    echo $(date) > ~/.rally/benchmarks/races/after.txt

    # collect metadata, write to this directory
    save_race_data "${btype}" "${enc_type}" "${p}"

    # they sometimes kill off each other
    sleep 5
  done
done
