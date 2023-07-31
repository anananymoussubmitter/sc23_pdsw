import glob
import os
import pprint
import re
import statistics

from dataclasses import dataclass
import itertools
import matplotlib.pyplot as plt
import numpy as np

# First, collect all the data points and amount of workers

# Since we collected the benchmarks on the fly, we have multiple folders
# of results
# For further parsing, here are all folders
CURL_PATHS = {
    "baseline": {
        1: {
            "nyc": "./resultcurl_baseline/nyc/baseline/1",
            "mri": "./resultcurl_baseline/mri/baseline/1"
        },
        31: {
            "nyc": "./resultcurl_baseline/nyc/baseline/31",
            "mri": "./resultcurl_baseline/mri/baseline/31"
        },
        127: {
            "nyc": "./resultcurl_baseline/nyc/baseline/127",
            "mri": "./resultcurl_baseline/mri/baseline/127"
        }
    },
    "luks": {
        1: {
            "nyc": "./resultcurl_luks_all/nyc/luks/1",
            "mri": "./resultcurl_luks_all/mri/luks/1"
        },
        31: {
            "nyc": "./resultcurl_luks_all/nyc/luks/31",
            "mri": "./resultcurl_luks_all/mri/luks/31"
        },
        127: {
            "nyc": "./resultcurl_luks_all/nyc/luks/127",
            "mri": "./resultcurl_luks_all/mri/luks/127"
        }
    },
    "gocryptfs": {
        1: {
            "nyc": "./resultcurl_gocryptfs/nyc/gocryptfs/1",
            "mri": "./resultcurl_gocryptfs/mri/gocryptfs/1"
        },
        31: {
            "nyc": "./resultcurl_gocryptfs/nyc/gocryptfs/31",
            "mri": "./resultcurl_gocryptfs/mri/gocryptfs/31"
        },
        127: {
            "nyc": "./resultcurl_gocryptfs/nyc/gocryptfs/127",
            "mri": "./resultcurl_gocryptfs/mri/gocryptfs/127"
        }
    },
    "abe": {
        1: {
            "nyc": "./resultcurl_abe/nyc/ABE/1",
            "mri": "./resultcurl_abe/mri/ABE/1"
        },
        31: {
            "nyc": "./resultcurl_abe/nyc/ABE/31",
            "mri": "./resultcurl_abe/mri/ABE/31"
        },
        127: {
            "nyc": "./resultcurl_abe/nyc/ABE/127",
            "mri": "./resultcurl_abe/mri/ABE/127"
        }
    }
}

RALLY_PATHS = {
    "baseline",
    "luks",
    "goc"
}

# We always had for every ES cluster node one load generator.
#
# But, due to rising error rates with more intensive benchmarks
# we had to switch up the workers (i.e. numbers of subprocesses) per
# load generator node.
#
# Those can be found here, needed to normalize the throughput data
CURL_WORKER = {
    "baseline": {
        1: {
            "nyc": 48,
            "mri": 48
        },
        31: {
            "nyc": 12,
            "mri": 12
        },
        127: {
            "nyc": 4,
            "mri": 4
        }
    },
    "luks": {
        1: {
            "nyc": 48,
            "mri": 24
        },
        31: {
            "nyc": 12,
            "mri": 12
        },
        127: {
            "nyc": 4,
            "mri": 4
        }
    },
    "gocryptfs": {
        1: {
            "nyc": 48,
            "mri": 24
        },
        31: {
            "nyc": 12,
            "mri": 12
        },
        127: {
            "nyc": 4,
            "mri": 4
        }
    },
    "abe": {
        1: {
            "nyc": 48,
            "mri": 8
        },
        31: {
            "nyc": 12,
            "mri": 12
        },
        127: {
            "nyc": 4,
            "mri": 4
        }
    }
}

NUMBER_OF_QUERIES = {
    "nyc": {
        "abe",
        "non-abe"
    }
}


# Next, we do some sanity checks

def get_files_in_directory(directory_path, extension=None):
    """
    Gets all files in a directory with a given extension.
    Extension == None => Return all files
    """
    ret = []
    if extension is None:
        filename = "*"
    else:
        filename = f"*.{extension}"

    for file_path in glob.glob(os.path.join(directory_path, filename)):
        if os.path.isfile(file_path):
            ret.append(file_path)
    return ret

def sanity_check_curl_files(filename):
    """
    This function checks whether the curl files contain any errors.
    This is done by checking against each expected string contained in a line
    """
    with open(filename, 'r') as fp:
        lines = fp.readlines()

    # if it is less than like 5 lines, there is sth missing
    if len(lines) <= 5:
        print(f"Too few lines ({len(lines)}): \"{filename}\"")

    for line in lines:
        # an empty line is always okay
        if line.strip() == "":
            continue
        # Otherwise, a normal plot would look like
        #
        # query   {"query":{"range":{"total_amount":{"gte":5,"lt":15}}}}
        # runs    50
        # error_count 0
        # real	1m15.173s
        # user	0m0.290s
        # sys	0m0.401s
        line_beginnings = ["query", "runs", "error_count", "real", "user", "sys"]
        if any(line.startswith(x) for x in line_beginnings):
            continue

        # Now we manually verify for each line of noise that they did not change or stop the benchmark

        # /benchmark_nyc_127.sh: line 53: 08: value too great for base (error token is "08")
        # sleep: invalid option
        # Try 'sleep --help' for more information.
        if "value too great for base" in line:
            continue
        if "sleep: invalid option" in line:
            continue
        if "for more information" in line:
            continue

        # "test" (debug print)
        if line.strip() == "test":
            continue

        # Otherwise we have some noise!
        # Let's look at it
        print(f"Unexpected input: \"{line.strip()}\" ({filename})")

def sanity_check_all_curl_files():
    for encryption_type in CURL_PATHS.keys():
        for cluster_size in CURL_PATHS[encryption_type].keys():
            nyc = CURL_PATHS[encryption_type][cluster_size]["nyc"]
            mri = CURL_PATHS[encryption_type][cluster_size]["mri"]
            for file in get_files_in_directory(nyc, "txt"):
                sanity_check_curl_files(file)
            for file in get_files_in_directory(mri, "txt"):
                sanity_check_curl_files(file)

def load_all_curl_files():
    ret = {}
    for encryption_type in CURL_PATHS.keys():
        ret[encryption_type] = {}
        for cluster_size in CURL_PATHS[encryption_type].keys():
            ret[encryption_type][cluster_size] = {}
            for benchmark_type in CURL_PATHS[encryption_type][cluster_size]:
                ret[encryption_type][cluster_size][benchmark_type] = []
                folder = CURL_PATHS[encryption_type][cluster_size][benchmark_type]
                for file in get_files_in_directory(folder, "txt"):
                    ret[encryption_type][cluster_size][benchmark_type].extend(extract_data(file))
    return ret

# baseline/31/nyc/[FILES]

def averge_out_all_curl_files(bench_type_not):
    ret = {}
    curls = load_all_curl_files()
    for encryption_type in CURL_PATHS.keys():
        ret[encryption_type] = {}
        for cluster_size in CURL_PATHS[encryption_type].keys():
            ret[encryption_type][cluster_size] = {}
            for benchmark_type in CURL_PATHS[encryption_type][cluster_size]:
                queries = curls[encryption_type][cluster_size][benchmark_type]
#                if encryption_type == 'abe':
#                    continue
                if benchmark_type == bench_type_not:
                    continue
                total_runs = 0
                total_time = 0
                #all_times = [time_to_seconds(x.real) for x in queries]
                #m = statistics.median(all_times)
                query_time = []
                i = 0
                print(encryption_type + '  ' + str(cluster_size) + '   ' + benchmark_type)
                total_errors = 0
                for elem in queries:
                    #if 'trip_distance' not in elem.query:
                    if 'match_all":{}' not in elem.query:
                        continue
                    total_runs += elem.runs
                    if elem.error_count != 0:
                        print('Error')
                    query_time.append(elem.real)
                    i += 1
                    total_time += time_to_seconds(elem.real)
#                    total_time += m

                all_times = [time_to_seconds(x.real) for x in queries]
                #all_times = [time_to_seconds(x) for x in query_time]
                #m = statistics.median(all_times)
                m = min(all_times)
                max_val = max(all_times)
                print('Min Time' + str(m))
                print('MAximum Zeit ' + str(max_val))
                print('avergage' + str(sum(all_times) / len(all_times)))
                total_time = m*i

                ops_s_worker = total_runs / total_time
                workers_total = CURL_WORKER[encryption_type][cluster_size][benchmark_type] * cluster_size
                ops_s_total = ops_s_worker * workers_total

                ret[encryption_type][cluster_size][benchmark_type] = ops_s_total
    return ret

@dataclass
class QueryData:
    query: str
    runs: int
    error_count: int
    real: str

def extract_data(filename):
    data_list = []
    with open(filename, 'r') as file:
        lines = file.readlines()

    current_entry = {}
    for line in lines:
        # Use regex to find lines with required fields and extract values
        query_match = re.match(r'query\s+(?:"query":)?(.+)', line)
        runs_match = re.match(r'runs\s+(\d+)', line)
        error_count_match = re.match(r'error_count\s+(\d+)', line)
        real_match = re.match(r'real\s+([\dms.]+)', line)

        if query_match:
            current_entry['query'] = query_match.group(1).strip()
        elif runs_match:
            current_entry['runs'] = int(runs_match.group(1))
        elif error_count_match:
            current_entry['error_count'] = int(error_count_match.group(1))
        elif real_match:
            current_entry['real'] = real_match.group(1)

        # If all fields are found, create a new data class instance
        if len(current_entry) == 4:
            data_list.append(QueryData(**current_entry))
            current_entry = {}  # Reset for the next entry

    return data_list

def time_to_seconds(time_str):
    # Regular expression to match minutes and seconds
    time_pattern = r'(?:(\d+)m)?(\d+\.\d+)s'
    match = re.match(time_pattern, time_str)

    if match:
        minutes = float(match.group(1)) if match.group(1) else 0
        seconds = float(match.group(2))
        total_seconds = (minutes * 60) + seconds
        return total_seconds
    else:
        raise ValueError("Invalid time format. Expected 'XmY.YYYs' or 'Y.YYYs'.")


def do_all_plots(avgs_mri, avgs_nyc):
    ax = plt.gca()
    marker = itertools.cycle(('o', 'v', '^', '<', '>', 's', '8', 'p'))

    fig, (ax1, ax2) = plt.subplots(1, 2)
    fig.suptitle('Throughput CURL Benchmark ')
    orig_color = next(ax._get_lines.prop_cycler)['color']
    marker = itertools.cycle(('o', '^', '<', '>'))
    #if encryption_type == 'abe':
    #    continue
    marker = itertools.cycle(('o', '^', '<', '>'))
    for encryption_type in CURL_PATHS.keys():
        if encryption_type == 'luks':
            ecrypt_name = 'LUKS'
        if encryption_type == 'gocryptfs':
            ecrypt_name = 'GoCryptFS'
        if encryption_type == 'abe':
            ecrypt_name = 'ABE'
        if encryption_type == 'baseline':
            ecrypt_name = 'Baseline'
        for benchmark_type in ["mri"]:
            xs = [1, 31, 127]
            ys = [avgs_mri[encryption_type][x][benchmark_type] for x in [1, 31, 127]]
            ys = [x / 1000 for x in ys]
        #            plt.plot(xs, ys, label=f"{benchmark_type} {encryption_type}")
            color = next(ax1._get_lines.prop_cycler)['color']
            ax1.plot(xs, ys, label=ecrypt_name, marker=next(marker), color=color)
            ax1.plot(xs, ys, '+', color=color)
            ax1.legend()
            ax1.set_xlabel("Number of Nodes")
            ax1.set_ylabel("Number of Normalized KOps/s")
            ax1.set_xticks(xs)
            ax1.set_title('MRI Custom Corpus')
    marker = itertools.cycle(('o', '^', '<', '>'))
    for encryption_type in CURL_PATHS.keys():
        if encryption_type == 'luks':
            ecrypt_name = 'LUKS'
        if encryption_type == 'gocryptfs':
            ecrypt_name = 'GoCryptFS'
        if encryption_type == 'abe':
            ecrypt_name = 'ABE'
        if encryption_type == 'baseline':
            ecrypt_name = 'Baseline'
        for benchmark_type in ["nyc"]:
            xs = [1, 31, 127]
            ys = [avgs_nyc[encryption_type][x][benchmark_type] for x in [1, 31, 127]]
            ys = [x / 1000 for x in ys]
        #            plt.plot(xs, ys, label=f"{benchmark_type} {encryption_type}")
            color = next(ax2._get_lines.prop_cycler)['color']
            ax2.plot(xs, ys, label=ecrypt_name, marker=next(marker), color=color)
            ax2.plot(xs, ys, '+', color=color)
            ax2.legend()
            ax2.set_xlabel("Number of Nodes")
            ax2.set_xticks(xs)
            ax2.set_title('NYC Taxis Corpus')

#    plt.legend()
#    plt.xlabel("number of nodes")
#    plt.ylabel("total ops/s")
#    plt.savefig('curl-scaling.png', bbox_inches="tight")
#    plt.show()

def main():
    #sanity_check_all_curl_files()
    avgs_nyc = averge_out_all_curl_files('mri')
    avgs_mri = averge_out_all_curl_files('nyc')
    do_all_plots(avgs_mri, avgs_nyc)

if __name__ == '__main__':
    main()

