# ES_HOSTS have the format ${IP}:9200,
ES_HOSTS="10.241.130.49:9200,10.241.130.51:9200,10.241.130.53:9200,10.241.130.55:9200,10.241.130.57:9200,10.241.130.59:9200,10.241.130.61:9200,10.241.130.63:9200,10.241.130.65:9200,10.241.130.67:9200,10.241.130.69:9200,10.241.130.71:9200,10.241.130.73:9200,10.241.130.75:9200,10.241.130.77:9200,10.241.130.79:9200,10.241.130.81:9200,10.241.130.83:9200,10.241.130.85:9200,10.241.130.87:9200,10.241.130.89:9200,10.241.130.91:9200,10.241.130.93:9200,10.241.130.95:9200,10.241.133.223:9200,10.241.133.225:9200,10.241.133.227:9200,10.241.133.229:9200,10.241.133.231:9200,10.241.133.233:9200,10.241.133.235:9200"
# Load driver dont have ports
# IMPORTANT
# THE COORDINATOR HAS TO BE WRITTEN AS THE FIRST LOAD_DRIVER_HOST!!!
# OTHERWISE IT WILL FAIL WITH AN CRYPTIC MESSAGE
# IMPORTANT
LOAD_DRIVER_HOSTS="10.241.130.49,10.241.130.51,10.241.130.53,10.241.130.55,10.241.130.57,10.241.130.59,10.241.130.61,10.241.130.63,10.241.130.65,10.241.130.67,10.241.130.69,10.241.130.71,10.241.130.73,10.241.130.75,10.241.130.77,10.241.130.79,10.241.130.81,10.241.130.83,10.241.130.85,10.241.130.87,10.241.130.89,10.241.130.91,10.241.130.93,10.241.130.95,10.241.133.223,10.241.133.225,10.241.133.227,10.241.133.229,10.241.133.231,10.241.133.233,10.241.133.235"

PATH_TO_BENCHMARKS="/scratch-emmy/usr/anon/sc/new_benchmarks/rally-tracks-throughput"
PATH_TO_ESRALLY="/scratch-emmy/usr/anon/sc/Python/bin/esrally"

# just for saving path
enc_type="ABE"
# just for saving path
RESULT_FOLDER="result31ABE"

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
#benchmark_types=("nyc_taxis_patched_31" "mrirally")
benchmark_types=("nyc_taxis_encrypted" "mrirally_encrypted")

# The actual runs
for btype in "${benchmark_types[@]}"; do
  for p in "${percentages[@]}"; do
    
    # debug just for us
    echo "$btype $p%"

    # save further metadata to collect after race
    echo $(date) > ~/.rally/benchmarks/races/before.txt
    echo $(hostname) > ~/.rally/benchmarks/races/hostname.txt
    echo $ES_HOSTS > ~/.rally/benchmarks/races/eshosts.txt
    echo $LOAD_DRIVER_HOSTS > ~/.rally/benchmarks/races/eshosts.txt

    # do the race
    #${PATH_TO_ESRALLY} race --test-mode --offline --track-path="${PATH_TO_BENCHMARKS}/${btype}" --pipeline=benchmark-only --target-hosts=${ES_HOSTS} --load-driver-hosts=${LOAD_DRIVER_HOSTS}
    ${PATH_TO_ESRALLY} race  --offline --track-path="${PATH_TO_BENCHMARKS}/${btype}" --pipeline=benchmark-only --target-hosts=${ES_HOSTS} --load-driver-hosts=${LOAD_DRIVER_HOSTS} --track-params="ingest_percentage:${p}"

    # save further metadata to collect after race
    echo $(date) > ~/.rally/benchmarks/races/after.txt

    # collect metadata, write to this directory
    save_race_data "${btype}" "${enc_type}" "${p}"

    # they sometimes kill off each other
    sleep 5
  done
done
