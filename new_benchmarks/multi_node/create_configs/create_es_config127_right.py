import os
import shutil
from dataclasses import dataclass
from typing import List

@dataclass
class Config:
    node_name: str
    node_roles: List[str]
    network_host: str
    initial_master_node: str
    discovery_seed_hosts: List[str]


DATA_ONLY_NODES = [
	("10.241.132.51", "gcn2563"),
	("10.241.132.52", "gcn2564"),
	("10.241.132.53", "gcn2565"),
	("10.241.132.54", "gcn2566"),
	("10.241.132.55", "gcn2567"),
	("10.241.132.56", "gcn2568"),
	("10.241.132.57", "gcn2569"),
	("10.241.132.58", "gcn2570"),
	("10.241.132.59", "gcn2571"),
	("10.241.132.60", "gcn2572"),
	("10.241.132.61", "gcn2573"),
	("10.241.132.62", "gcn2574"),
	("10.241.132.63", "gcn2575"),
	("10.241.132.64", "gcn2576"),
	("10.241.132.113", "gcn2625"),
	("10.241.132.114", "gcn2626"),
	("10.241.132.115", "gcn2627"),
	("10.241.132.116", "gcn2628"),
	("10.241.132.117", "gcn2629"),
	("10.241.132.118", "gcn2630"),
	("10.241.132.119", "gcn2631"),
	("10.241.132.120", "gcn2632"),
	("10.241.132.121", "gcn2633"),
	("10.241.132.122", "gcn2634"),
	("10.241.132.123", "gcn2635"),
	("10.241.132.124", "gcn2636"),
	("10.241.132.125", "gcn2637"),
	("10.241.132.126", "gcn2638"),
	("10.241.132.127", "gcn2639"),
	("10.241.132.128", "gcn2640"),
	("10.241.132.129", "gcn2641"),
	("10.241.132.130", "gcn2642"),
	("10.241.132.131", "gcn2643"),
	("10.241.132.132", "gcn2644"),
	("10.241.132.133", "gcn2645"),
	("10.241.132.134", "gcn2646"),
	("10.241.132.135", "gcn2647"),
	("10.241.132.136", "gcn2648"),
	("10.241.132.137", "gcn2649"),
	("10.241.132.138", "gcn2650"),
	("10.241.132.139", "gcn2651"),
	("10.241.132.140", "gcn2652"),
	("10.241.132.141", "gcn2653"),
	("10.241.132.142", "gcn2654"),
	("10.241.132.143", "gcn2655"),
	("10.241.132.144", "gcn2656"),
	("10.241.132.145", "gcn2657"),
	("10.241.132.146", "gcn2658"),
	("10.241.132.147", "gcn2659"),
	("10.241.132.148", "gcn2660"),
	("10.241.132.149", "gcn2661"),
	("10.241.132.150", "gcn2662"),
	("10.241.132.151", "gcn2663"),
	("10.241.132.152", "gcn2664"),
	("10.241.132.153", "gcn2665"),
	("10.241.132.154", "gcn2666"),
	("10.241.132.155", "gcn2667"),
	("10.241.132.156", "gcn2668"),
	("10.241.132.157", "gcn2669"),
	("10.241.132.158", "gcn2670"),
	("10.241.132.159", "gcn2671"),
	("10.241.132.160", "gcn2672"),
	("10.241.132.164", "gcn2676"),
	("10.241.132.166", "gcn2678"),
	("10.241.132.176", "gcn2688"),
	("10.241.132.178", "gcn2690"),
	("10.241.132.180", "gcn2692"),
	("10.241.132.182", "gcn2694"),
	("10.241.132.184", "gcn2696"),
	("10.241.132.186", "gcn2698"),
	("10.241.132.188", "gcn2700"),
	("10.241.132.190", "gcn2702"),
	("10.241.132.192", "gcn2704"),
	("10.241.132.194", "gcn2706"),
	("10.241.132.196", "gcn2708"),
	("10.241.132.198", "gcn2710"),
	("10.241.132.202", "gcn2714"),
	("10.241.132.204", "gcn2716"),
	("10.241.132.206", "gcn2718"),
	("10.241.132.208", "gcn2720"),
	("10.241.132.209", "gcn2721"),
	("10.241.132.210", "gcn2722"),
	("10.241.132.211", "gcn2723"),
	("10.241.132.212", "gcn2724"),
	("10.241.132.213", "gcn2725"),
	("10.241.132.214", "gcn2726"),
	("10.241.132.215", "gcn2727"),
	("10.241.132.216", "gcn2728"),
	("10.241.132.217", "gcn2729"),
	("10.241.132.218", "gcn2730"),
	("10.241.132.219", "gcn2731"),
	("10.241.132.220", "gcn2732"),
	("10.241.132.221", "gcn2733"),
	("10.241.132.222", "gcn2734"),
	("10.241.132.223", "gcn2735"),
	("10.241.132.224", "gcn2736"),
	("10.241.132.225", "gcn2737"),
	("10.241.132.226", "gcn2738"),
	("10.241.132.227", "gcn2739"),
	("10.241.132.228", "gcn2740"),
	("10.241.132.229", "gcn2741"),
	("10.241.132.230", "gcn2742"),
	("10.241.132.231", "gcn2743"),
	("10.241.132.232", "gcn2744"),
	("10.241.132.233", "gcn2745"),
	("10.241.132.234", "gcn2746"),
	("10.241.132.235", "gcn2747"),
	("10.241.132.236", "gcn2748"),
	("10.241.132.237", "gcn2749"),
	("10.241.132.238", "gcn2750"),
	("10.241.132.239", "gcn2751"),
	("10.241.132.240", "gcn2752"),
	("10.241.132.241", "gcn2753"),
	("10.241.132.242", "gcn2754"),
	("10.241.132.243", "gcn2755"),
	("10.241.132.244", "gcn2756"),
	("10.241.132.245", "gcn2757"),
	("10.241.132.246", "gcn2758"),
	("10.241.132.247", "gcn2759"),
	("10.241.132.248", "gcn2760"),
	("10.241.132.249", "gcn2761"),
	("10.241.132.250", "gcn2762"),
	("10.241.132.251", "gcn2763"),
	("10.241.132.252", "gcn2764"),
	("10.241.132.253", "gcn2765"),
]
MASTER_NODES = [
	("10.241.132.48", "gcn2560"),
	("10.241.132.49", "gcn2561"),
	("10.241.132.50", "gcn2562"),
]
INITIAL_MASTER_NODE = "10.241.132.48" 
DISCOVERY_SEED_HOSTS = [
INITIAL_MASTER_NODE
]

def generate_config_file(config: Config) -> str:
    cluster_name = "secure-data-lake"
    xpack_security_enabled = False

    node_roles_str = ", ".join(f'"{role}"' for role in config.node_roles)
    initial_master_node_str = f'"{config.initial_master_node}"'
    discovery_seed_hosts_str = ", ".join(f'"{host}"' for host in config.discovery_seed_hosts)

    config_content = f"""cluster.name: {cluster_name}
node.name: {config.node_name}
node.roles: [{node_roles_str}]
network.host: {config.network_host}
cluster.initial_master_nodes: [{initial_master_node_str}]
discovery.seed_hosts: [{discovery_seed_hosts_str}]
xpack.security.enabled: {str(xpack_security_enabled).lower()}
"""

    return config_content

def generate_config_with_fs(config: Config):
    destination_folder = f"./{config.node_name}"
    os.makedirs(destination_folder, exist_ok=True)

    base_config_folder = "./base-config"
    for item in os.listdir(base_config_folder):
        item_path = os.path.join(base_config_folder, item)
        if os.path.isfile(item_path):
            shutil.copy(item_path, destination_folder)
        elif os.path.isdir(item_path):
            shutil.copytree(item_path, os.path.join(destination_folder, item))

    config_content = generate_config_file(config)

    config_file_path = os.path.join(destination_folder, "elasticsearch.yml")
    with open(config_file_path, "w") as config_file:
        config_file.write(config_content)

def main():
    # data_only
    for (data_node_ip, node_name) in DATA_ONLY_NODES:
        node_roles = ["data"]
        network_host = data_node_ip
        initial_master_node = INITIAL_MASTER_NODE
        discovery_seed_hosts = DISCOVERY_SEED_HOSTS

        config_data = Config(
            node_name=node_name,
            node_roles=node_roles,
            network_host=network_host,
            initial_master_node=initial_master_node,
            discovery_seed_hosts=discovery_seed_hosts
        )

        generate_config_with_fs(config_data)

    # data/master
    for (master_node_ip, node_name) in MASTER_NODES:
        node_roles = ["data", "master"]
        network_host = master_node_ip
        initial_master_node = INITIAL_MASTER_NODE
        discovery_seed_hosts = DISCOVERY_SEED_HOSTS

        config_data = Config(
            node_name=node_name,
            node_roles=node_roles,
            network_host=network_host,
            initial_master_node=initial_master_node,
            discovery_seed_hosts=discovery_seed_hosts
        )

        generate_config_with_fs(config_data)

if __name__ == "__main__":
    main()

