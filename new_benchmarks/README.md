## Overview of current folder

- `build_singularity.sh` can be used to build the ES container. It requires docker and singularity to be installed. This can be done on a local machine, i.e. it is not required to intall docker on a HPC node
- `single_node` contains the files to start a single node ES cluster for different storage paths. It expects the singularity container to be build before.
- `multi_node` contains the files to start the multi node ES cluster. See the root README for more inforamtion on how to use
- `queries` contains the scripts for the non-rally benchmark
- `rally` contains the scripts for the rally coordinator
- `rally-tracks-throughput` contains our patched corpra. Based on [`rally-tracks`](https://github.com/elastic/rally-tracks), see its readme for more information
