# ES_HOSTS have the format ${IP}:9200,
#ES_HOSTS="10.241.130.49:9200,10.241.130.51:9200,10.241.130.53:9200,10.241.130.55:9200,10.241.130.57:9200,10.241.130.59:9200,10.241.130.61:9200,10.241.130.63:9200,10.241.130.65:9200,10.241.130.67:9200,10.241.130.69:9200,10.241.130.71:9200,10.241.130.73:9200,10.241.130.75:9200,10.241.130.77:9200,10.241.130.79:9200,10.241.130.81:9200,10.241.130.83:9200,10.241.130.85:9200,10.241.130.87:9200,10.241.130.89:9200,10.241.130.91:9200,10.241.130.93:9200,10.241.130.95:9200,10.241.133.223:9200,10.241.133.225:9200,10.241.133.227:9200,10.241.133.229:9200,10.241.133.231:9200,10.241.133.233:9200,10.241.133.235:9200"
ES_HOSTS="10.241.132.17:9200"

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
#benchmark_types=("mrirally_ingest_only_31" "nyc_taxis_ingest_only_31" )
benchmark_types=("nyc_taxis_encrypted_ingest_only_31" "mrirally_encrypted_ingest_only_31")

# The actual runs
for btype in "${benchmark_types[@]}"; do
    
    # debug just for us
    echo "$btype"

    ${PATH_TO_ESRALLY} race --offline --track-path="${PATH_TO_BENCHMARKS}/${btype}" --pipeline=benchmark-only --target-hosts=${ES_HOSTS}

    # they sometimes kill off each other
    sleep 5
done
