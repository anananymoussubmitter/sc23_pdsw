# ES_HOSTS have the format ${IP}:9200,
#ES_HOSTS="10.241.130.145:9200,10.241.130.147:9200,10.241.130.149:9200,10.241.130.151:9200,10.241.130.153:9200,10.241.130.155:9200,10.241.130.159:9200,10.241.130.161:9200,10.241.130.163:9200,10.241.130.165:9200,10.241.130.167:9200,10.241.130.169:9200,10.241.130.171:9200,10.241.130.173:9200,10.241.130.175:9200,10.241.130.177:9200,10.241.130.179:9200,10.241.130.181:9200,10.241.130.183:9200,10.241.130.185:9200,10.241.130.187:9200,10.241.130.189:9200,10.241.130.191:9200,10.241.130.241:9200,10.241.130.243:9200,10.241.130.245:9200,10.241.130.247:9200,10.241.130.249:9200,10.241.130.251:9200,10.241.130.253:9200,10.241.130.255:9200,10.241.131.1:9200,10.241.131.3:9200,10.241.131.5:9200,10.241.131.7:9200,10.241.131.9:9200,10.241.131.11:9200,10.241.131.13:9200,10.241.131.15:9200,10.241.131.17:9200,10.241.131.19:9200,10.241.131.21:9200,10.241.131.23:9200,10.241.131.25:9200,10.241.131.27:9200,10.241.131.29:9200,10.241.131.31:9200,10.241.131.81:9200,10.241.131.83:9200,10.241.131.85:9200,10.241.131.87:9200,10.241.131.89:9200,10.241.131.91:9200,10.241.131.93:9200,10.241.131.95:9200,10.241.131.97:9200,10.241.131.99:9200,10.241.131.101:9200,10.241.131.103:9200,10.241.131.105:9200,10.241.131.107:9200,10.241.131.109:9200,10.241.131.111:9200,10.241.131.113:9200,10.241.131.115:9200,10.241.131.117:9200,10.241.131.119:9200,10.241.131.121:9200,10.241.131.123:9200,10.241.131.125:9200,10.241.131.127:9200,10.241.131.177:9200,10.241.131.179:9200,10.241.131.181:9200,10.241.131.183:9200,10.241.131.185:9200,10.241.131.187:9200,10.241.131.189:9200,10.241.131.191:9200,10.241.131.193:9200,10.241.131.195:9200,10.241.131.197:9200,10.241.131.199:9200,10.241.131.201:9200,10.241.131.203:9200,10.241.131.205:9200,10.241.131.207:9200,10.241.131.209:9200,10.241.131.211:9200,10.241.131.213:9200,10.241.131.215:9200,10.241.131.217:9200,10.241.131.219:9200,10.241.131.221:9200,10.241.131.223:9200,10.241.132.17:9200,10.241.132.18:9200,10.241.132.19:9200,10.241.132.20:9200,10.241.132.21:9200,10.241.132.22:9200,10.241.132.23:9200,10.241.132.24:9200,10.241.132.25:9200,10.241.132.26:9200,10.241.132.27:9200,10.241.132.28:9200,10.241.132.29:9200,10.241.132.30:9200,10.241.132.31:9200,10.241.132.32:9200,10.241.132.33:9200,10.241.132.34:9200,10.241.132.35:9200,10.241.132.36:9200,10.241.132.37:9200,10.241.132.38:9200,10.241.132.39:9200,10.241.132.40:9200,10.241.132.41:9200,10.241.132.42:9200,10.241.132.43:9200,10.241.132.44:9200,10.241.132.45:9200,10.241.132.46:9200,10.241.132.47:9200,10.241.132.48:9200"
ES_HOSTS="10.241.130.145:9200"

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
benchmark_types=("nyc_taxis_encrypted_ingest_only_127" "mrirally_encrypted_ingest_only_127")
#benchmark_types=("nyc_taxis_ingest_only_127" "mrirally_ingest_only_127")


# The actual runs
for btype in "${benchmark_types[@]}"; do
    
    # debug just for us
    echo "$btype"

    # do the ingest
    ${PATH_TO_ESRALLY} race  --offline --track-path="${PATH_TO_BENCHMARKS}/${btype}" --pipeline=benchmark-only --target-hosts=${ES_HOSTS}

    # they sometimes kill off each other
    sleep 5
done
