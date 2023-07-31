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
	("10.241.130.55", "gcn2055"), 
	("10.241.130.57", "gcn2057"), 
	("10.241.130.59", "gcn2059"), 
	("10.241.130.61", "gcn2061"), 
	("10.241.130.63", "gcn2063"), 
	("10.241.130.65", "gcn2065"), 
	("10.241.130.67", "gcn2067"), 
	("10.241.130.69", "gcn2069"), 
	("10.241.130.71", "gcn2071"), 
	("10.241.130.73", "gcn2073"), 
	("10.241.130.75", "gcn2075"), 
	("10.241.130.77", "gcn2077"), 
	("10.241.130.79", "gcn2079"), 
	("10.241.130.81", "gcn2081"), 
	("10.241.130.83", "gcn2083"), 
	("10.241.130.85", "gcn2085"), 
	("10.241.130.87", "gcn2087"), 
	("10.241.130.89", "gcn2089"), 
	("10.241.130.91", "gcn2091"), 
	("10.241.130.93", "gcn2093"), 
	("10.241.130.95", "gcn2095"), 
	("10.241.133.223", "gcn2991"), 
	("10.241.133.225", "gcn2993"), 
	("10.241.133.227", "gcn2995"), 
	("10.241.133.229", "gcn2997"), 
	("10.241.133.231", "gcn2999"), 
	("10.241.133.233", "gcn3001"), 
	("10.241.133.235", "gcn3003")
]
MASTER_NODES = [
	("10.241.130.49", "gcn2049"), 
	("10.241.130.51", "gcn2051"), 
	("10.241.130.53", "gcn2053")
]
INITIAL_MASTER_NODE = "10.241.130.49"
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

