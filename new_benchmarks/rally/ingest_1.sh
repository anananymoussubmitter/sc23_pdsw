PATH_TO_BENCHMARKS="/scratch-emmy/usr/gzadmhno/sc/new_benchmarks/rally-tracks-throughput"
PATH_TO_ESRALLY="/scratch-emmy/usr/gzadmhno/sc/Python/bin/esrally"

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

is_running
benchmark_types=("nyc_taxis_ingest_only_1" "mrirally_ingest_only_1")
#benchmark_types=("nyc_taxis_encrypted_ingest_only_1" "mrirally_encrypted_ingest_only_1")

# The actual runs
for btype in "${benchmark_types[@]}"; do
    
    # debug just for us
    echo "$btype"

    ${PATH_TO_ESRALLY} race --offline --track-path="${PATH_TO_BENCHMARKS}/${btype}" --pipeline=benchmark-only --target-hosts=gcn2145:9200

    # they sometimes kill off each other
    sleep 5
done
