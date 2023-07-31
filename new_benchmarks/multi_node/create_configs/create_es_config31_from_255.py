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
	("10.241.132.20", "gcn2532"),
	("10.241.132.21", "gcn2533"),
	("10.241.132.22", "gcn2534"),
	("10.241.132.23", "gcn2535"),
	("10.241.132.24", "gcn2536"),
	("10.241.132.25", "gcn2537"),
	("10.241.132.26", "gcn2538"),
	("10.241.132.27", "gcn2539"),
	("10.241.132.28", "gcn2540"),
	("10.241.132.29", "gcn2541"),
	("10.241.132.30", "gcn2542"),
	("10.241.132.31", "gcn2543"),
	("10.241.132.32", "gcn2544"),
	("10.241.132.33", "gcn2545"),
	("10.241.132.34", "gcn2546"),
	("10.241.132.35", "gcn2547"),
	("10.241.132.36", "gcn2548"),
	("10.241.132.37", "gcn2549"),
	("10.241.132.38", "gcn2550"),
	("10.241.132.39", "gcn2551"),
	("10.241.132.40", "gcn2552"),
	("10.241.132.41", "gcn2553"),
	("10.241.132.42", "gcn2554"),
	("10.241.132.43", "gcn2555"),
	("10.241.132.44", "gcn2556"),
	("10.241.132.45", "gcn2557"),
	("10.241.132.46", "gcn2558"),
	("10.241.132.47", "gcn2559")
]
MASTER_NODES = [
	("10.241.132.17", "gcn2529"),
	("10.241.132.18", "gcn2530"),
	("10.241.132.19", "gcn2531")
]
INITIAL_MASTER_NODE = "10.241.132.17"
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

