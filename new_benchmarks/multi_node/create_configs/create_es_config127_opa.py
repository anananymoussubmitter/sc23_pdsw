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
	("10.246.130.151", "gcn2151"),
	("10.246.130.153", "gcn2153"),
	("10.246.130.155", "gcn2155"),
	("10.246.132.48", "gcn2560"),
	("10.246.130.159", "gcn2159"),
	("10.246.130.161", "gcn2161"),
	("10.246.130.163", "gcn2163"),
	("10.246.130.165", "gcn2165"),
	("10.246.130.167", "gcn2167"),
	("10.246.130.169", "gcn2169"),
	("10.246.130.171", "gcn2171"),
	("10.246.130.173", "gcn2173"),
	("10.246.130.175", "gcn2175"),
	("10.246.130.177", "gcn2177"),
	("10.246.130.179", "gcn2179"),
	("10.246.130.181", "gcn2181"),
	("10.246.130.183", "gcn2183"),
	("10.246.130.185", "gcn2185"),
	("10.246.130.187", "gcn2187"),
	("10.246.130.189", "gcn2189"),
	("10.246.130.191", "gcn2191"),
	("10.246.130.241", "gcn2241"),
	("10.246.130.243", "gcn2243"),
	("10.246.130.245", "gcn2245"),
	("10.246.130.247", "gcn2247"),
	("10.246.130.249", "gcn2249"),
	("10.246.130.251", "gcn2251"),
	("10.246.130.253", "gcn2253"),
	("10.246.130.255", "gcn2255"),
	("10.246.131.1", "gcn2257"),
	("10.246.131.3", "gcn2259"),
	("10.246.131.5", "gcn2261"),
	("10.246.131.7", "gcn2263"),
	("10.246.131.9", "gcn2265"),
	("10.246.131.11", "gcn2267"),
	("10.246.131.13", "gcn2269"),
	("10.246.131.15", "gcn2271"),
	("10.246.131.17", "gcn2273"),
	("10.246.131.19", "gcn2275"),
	("10.246.131.21", "gcn2277"),
	("10.246.131.23", "gcn2279"),
	("10.246.131.25", "gcn2281"),
	("10.246.131.27", "gcn2283"),
	("10.246.131.29", "gcn2285"),
	("10.246.131.31", "gcn2287"),
	("10.246.131.81", "gcn2337"),
	("10.246.131.83", "gcn2339"),
	("10.246.131.85", "gcn2341"),
	("10.246.131.87", "gcn2343"),
	("10.246.131.89", "gcn2345"),
	("10.246.131.91", "gcn2347"),
	("10.246.131.93", "gcn2349"),
	("10.246.131.95", "gcn2351"),
	("10.246.131.97", "gcn2353"),
	("10.246.131.99", "gcn2355"),
	("10.246.131.101", "gcn2357"),
	("10.246.131.103", "gcn2359"),
	("10.246.131.105", "gcn2361"),
	("10.246.131.107", "gcn2363"),
	("10.246.131.109", "gcn2365"),
	("10.246.131.111", "gcn2367"),
	("10.246.131.113", "gcn2369"),
	("10.246.131.115", "gcn2371"),
	("10.246.131.117", "gcn2373"),
	("10.246.131.119", "gcn2375"),
	("10.246.131.121", "gcn2377"),
	("10.246.131.123", "gcn2379"),
	("10.246.131.125", "gcn2381"),
	("10.246.131.127", "gcn2383"),
	("10.246.131.177", "gcn2433"),
	("10.246.131.179", "gcn2435"),
	("10.246.131.181", "gcn2437"),
	("10.246.131.183", "gcn2439"),
	("10.246.131.185", "gcn2441"),
	("10.246.131.187", "gcn2443"),
	("10.246.131.189", "gcn2445"),
	("10.246.131.191", "gcn2447"),
	("10.246.131.193", "gcn2449"),
	("10.246.131.195", "gcn2451"),
	("10.246.131.197", "gcn2453"),
	("10.246.131.199", "gcn2455"),
	("10.246.131.201", "gcn2457"),
	("10.246.131.203", "gcn2459"),
	("10.246.131.205", "gcn2461"),
	("10.246.131.207", "gcn2463"),
	("10.246.131.209", "gcn2465"),
	("10.246.131.211", "gcn2467"),
	("10.246.131.213", "gcn2469"),
	("10.246.131.215", "gcn2471"),
	("10.246.131.217", "gcn2473"),
	("10.246.131.219", "gcn2475"),
	("10.246.131.221", "gcn2477"),
	("10.246.131.223", "gcn2479"),
	("10.246.132.17", "gcn2529"),
	("10.246.132.18", "gcn2530"),
	("10.246.132.19", "gcn2531"),
	("10.246.132.20", "gcn2532"),
	("10.246.132.21", "gcn2533"),
	("10.246.132.22", "gcn2534"),
	("10.246.132.23", "gcn2535"),
	("10.246.132.24", "gcn2536"),
	("10.246.132.25", "gcn2537"),
	("10.246.132.26", "gcn2538"),
	("10.246.132.27", "gcn2539"),
	("10.246.132.28", "gcn2540"),
	("10.246.132.29", "gcn2541"),
	("10.246.132.30", "gcn2542"),
	("10.246.132.31", "gcn2543"),
	("10.246.132.32", "gcn2544"),
	("10.246.132.33", "gcn2545"),
	("10.246.132.34", "gcn2546"),
	("10.246.132.35", "gcn2547"),
	("10.246.132.36", "gcn2548"),
	("10.246.132.37", "gcn2549"),
	("10.246.132.38", "gcn2550"),
	("10.246.132.39", "gcn2551"),
	("10.246.132.40", "gcn2552"),
	("10.246.132.41", "gcn2553"),
	("10.246.132.42", "gcn2554"),
	("10.246.132.43", "gcn2555"),
	("10.246.132.44", "gcn2556"),
	("10.246.132.45", "gcn2557"),
	("10.246.132.46", "gcn2558"),
	("10.246.132.47", "gcn2559")
]
MASTER_NODES = [
	("10.246.130.145", "gcn2145"),
	("10.246.130.147", "gcn2147"),
	("10.246.130.149", "gcn2149")
]
INITIAL_MASTER_NODE = "10.246.130.145"
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

