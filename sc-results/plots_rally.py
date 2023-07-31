import json

import matplotlib.pyplot as plt

import itertools

RALLY_PATHS = {
    "Baseline": {
        1: {
            10: {
                "nyc": "./results1node/nyc_taxis/none/10/702be5f5-6d7f-4638-87c6-57167691f71a/race.json",
                "mri": "./results1node/mrirally/none/10/c0c9285a-f98e-4648-8f88-d98074a4427e/race.json"
            },
            100: {
                "nyc": "./results1node/nyc_taxis/none/100/db2f41cd-d282-4d1f-b6eb-49a993e2a61c/race.json",
                "mri": "./results1node/mrirally/none/100/2ec2fe98-b899-49f1-a9e9-dfa312a5f075/race.json"
            }
        },
        31: {
            10: {
                "nyc": "./resulthno31lustre/resulthno31lustre/nyc_taxis_patched_31/baseline/10/51667ab0-d292-4b07-9d4e-0cbe478d7c21/race.json",
                "mri": "./resulthno31lustre/resulthno31lustre/mrirally/baseline/10/0fce62b3-4186-4ad9-b257-8bfcb5cc27d7/race.json"
            },
            100: {
                "nyc": "./resulthno31lustre/resulthno31lustre/nyc_taxis_patched_31/baseline/100/dae7a23d-61bd-4ab5-915f-d3ae39391b3b/race.json",
                "mri": "./resulthno31lustre/resulthno31lustre/mrirally/baseline/100/076008f1-012f-4c77-b64d-cd7cd107fd44/race.json"
            }
        },
    },
    "LUKS": {
        1: {
            10: {
                "nyc": "./results1node/nyc_taxis/luks/10/ee499580-e922-4162-a3ed-b4c2ac0117c5/race.json",
                "mri": "./results1node/mrirally/luks/10/d679bd89-abd1-4d04-ba8d-b20a6569c529/race.json"
            },
            100: {
                "nyc": "./results1node/nyc_taxis/luks/100/5b79c56b-f204-4b8b-8e9c-d83ee1211a1d/race.json",
                "mri": "./results1node/mrirally/luks/100/f8b8b197-8f9e-42c8-8488-040e269c46d4/race.json"
            }
        },
        31: {
            10: {
                "nyc": "./resulthno31lustre/resulthno31lustre/nyc_taxis_patched_31/luks/10/0b4bf3d9-5030-49a7-9f32-a734ad73317d/race.json",
                "mri": "./resulthno31lustre/resulthno31lustre/mrirally/luks/10/68ed2fe4-b517-4357-a337-5b307ecd927d/race.json"
            },
            100: {
                "nyc": "./resulthno31lustre/resulthno31lustre/nyc_taxis_patched_31/luks/100/d633df2d-e72b-4060-91bd-26b741f76b31/race.json",
                "mri": "./resulthno31lustre/resulthno31lustre/mrirally/luks/100/eea9aecd-4994-493c-8cf5-a0e9a5b16852/race.json"
            }
        }
    },
    "GoCryptFS": {
        1: {
            10: {
                "nyc": "./results1node/nyc_taxis/gocryptfs/10/3598ed24-9a45-4ead-b3e9-2867176e87c8/race.json",
                "mri": "./results1node/mrirally/gocryptfs/10/45902b3b-abb3-44ff-884c-cc751bd8515e/race.json"
            },
            100: {
                "nyc": "./results1node/nyc_taxis/gocryptfs/100/12e43412-b85b-4760-bff5-8eb206c86dcf/race.json",
                "mri": "./results1node/mrirally/gocryptfs/100/4f3a86d3-969a-4078-a5cf-66d96516962d/race.json"
            }
        },
        31: {
            10: {
                "nyc": "./resulthno31lustre/resulthno31lustre/nyc_taxis_patched_31/gocryptfs/10/146caafc-9447-4bcf-9ba0-dfa4b46da25a/race.json",
                "mri": "./resulthno31lustre/resulthno31lustre/mrirally/gocryptfs/10/f61a39e4-f503-4a50-a7cb-570aa92a7c5c/race.json"
            },
            100: {
                "nyc": "./resulthno31lustre/resulthno31lustre/nyc_taxis_patched_31/gocryptfs/100/1c5c76ea-34af-4c79-962f-ddadfde1cc6e/race.json",
                "mri": "./resulthno31lustre/resulthno31lustre/mrirally/gocryptfs/100/3ef48c3b-d969-4e47-bed7-11196ad12eec/race.json"
            }
        }
    },
    "ABE": {
        1: {
            10: {
                "nyc": "./results1node/nyc_taxis_encrypted_1/ABE/10/cf73ce89-120d-422b-9a95-958683fce3b1/race.json",
                "mri": "./results1node/mrirally_encrypted_1/ABE/10/bf3df31e-9bf2-4136-a7b2-a6a28b0519e7/race.json"
            },
            100: {
                "nyc": "./results1node/nyc_taxis_encrypted_1/ABE/100/b2b59a0b-313c-4925-b0e9-0dff512e4a71/race.json",
                "mri": "./results1node/mrirally_encrypted_1/ABE/100/1c40ccd9-0c15-4ac0-8664-5f9c9049e802/race.json"
            }
        },
        31: {
            10: {
                "nyc": "./resulthno31lustre/result31ABE/nyc_taxis_encrypted/ABE/10/4eb537f1-9390-4c4c-a82b-0a800275feeb/race.json",
                "mri": "./resulthno31lustre/result31ABE/mrirally_encrypted/ABE/10/c52afb2f-5a1b-48e2-a9a7-8fd2093a74e4/race.json"
            },
            100: {
                "nyc": "./resulthno31lustre/result31ABE/nyc_taxis_encrypted/ABE/100/587f8e4c-cade-46c7-94ce-335c196e53db/race.json",
                "mri": "./resulthno31lustre/result31ABE/mrirally_encrypted/ABE/100/94439627-f14f-47cd-8a13-19d7c12992dd/race.json"
            }
        }
    }
}

def load_jsons():
    ret = {}
    for encryption_type in RALLY_PATHS:
        ret[encryption_type] = {}
        for cluster_size in RALLY_PATHS[encryption_type]:
            ret[encryption_type][cluster_size] = {}
            for ingest_percentage in RALLY_PATHS[encryption_type][cluster_size]:
                ret[encryption_type][cluster_size][ingest_percentage] = {}
                for benchmark_type in RALLY_PATHS[encryption_type][cluster_size][ingest_percentage]:
                    path = RALLY_PATHS[encryption_type][cluster_size][ingest_percentage][benchmark_type]
                    with open(path, 'r') as fp:
                        j = json.load(fp)
                    ret[encryption_type][cluster_size][ingest_percentage][benchmark_type] = j
    return ret

def plot():
    jsons = load_jsons()
    # CHANGE ME IF NEEDED
    corpus_size = 10
    benchmark_type = "nyc"
    metric_type = "throughput"
    # possible metrics: min/mean/median/max
    task = "default"
    metric = "mean"
    
    ax = plt.gca()
    marker = itertools.cycle(('o', 'v', '^', '<', '>', 's', '8', 'p'))

    fig, (ax1, ax2) = plt.subplots(1, 2)
    fig.suptitle('Default Query on NYC Taxis')
    orig_color = next(ax._get_lines.prop_cycler)['color']
    orig_marker = next(marker)

    for encryption_type in RALLY_PATHS:
        json_1 = jsons[encryption_type][1][corpus_size][benchmark_type]
        json_31 = jsons[encryption_type][31][corpus_size][benchmark_type]

        # find task we are intested in
        task_1 = None
        task_31 = None
        for t in json_1["results"]["op_metrics"]:
            #if task in t["task"]:
            if task == t["task"]:
                task_1 = t
        if task_1 is None:
            continue
        for t in json_31["results"]["op_metrics"]:
            #if task in t["task"]:
            if task == t["task"]:
                task_31 = t
        if task_31 is None:
            continue
        # extract the metric
        xs = [1, 31]
        print(encryption_type)
        ys = [
            task_1[metric_type][metric],
            task_31[metric_type][metric]
        ]
        print(encryption_type)
        print(xs)
        print(ys)
        print("-----------")
        color = next(ax1._get_lines.prop_cycler)['color']
        ax1.plot(xs, ys, label=encryption_type,marker=next(marker) ,color=color)
        ax1.plot(xs, ys, '+',color=color)
        ax1.legend()
        ax1.set_xlabel("Number of Nodes")
        ax1.set_ylabel("Number of Ops/s")
        ax1.set_xticks(xs)
        ax1.set_title('10% Corpus')
    marker = itertools.cycle(('o', '^', '<', '>'))
    corpus_size = 100    
    for encryption_type in RALLY_PATHS:
        json_1 = jsons[encryption_type][1][corpus_size][benchmark_type]
        json_31 = jsons[encryption_type][31][corpus_size][benchmark_type]

        # find task we are intested in
        task_1 = None
        task_31 = None
        for t in json_1["results"]["op_metrics"]:
            #if task in t["task"]:
            if task == t["task"]:
                task_1 = t
        if task_1 is None:
            continue
        for t in json_31["results"]["op_metrics"]:
            #if task in t["task"]:
            if task == t["task"]:
                task_31 = t
        if task_31 is None:
            continue
        # extract the metric
        xs = [1, 31]
        print(encryption_type)
        ys = [
            task_1[metric_type][metric],
            task_31[metric_type][metric]
        ]
        print(encryption_type)
        print(xs)
        print(ys)
        print("-----------")
        color = next(ax2._get_lines.prop_cycler)['color']
        ax2.plot(xs, ys, label=encryption_type,marker=next(marker) ,color=color)
        ax2.plot(xs, ys, '+',color=color)
        ax2.legend()
        ax2.set_xlabel("Number of Nodes")
#        ax2.set_ylabel("Number of Ops/s")
        ax2.set_xticks(xs)
        ax2.set_title('100% Corpus')
    plt.show()
    #plt.savefig('nyc-scaling.png', bbox_inches="tight")


def main():
    plot()
    #plot_double_y()

if __name__ == '__main__':
    main()
