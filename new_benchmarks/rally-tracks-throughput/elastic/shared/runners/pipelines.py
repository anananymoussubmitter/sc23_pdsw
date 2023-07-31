# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

import json
import os
from pathlib import Path


async def create_pipeline(es, params):
    pipeline_num = 0

    paths = []
    if "track-path" in params:
        paths += [Path(os.path.join(params["track-path"], params.get("pipelines", "pipelines")))]
    if "asset-paths" in params:
        paths += [Path(os.path.join(path, "ingest_pipelines")) for path in params["asset-paths"]]

    for path in paths:
        for p in path.rglob("*.json"):
            name = os.path.splitext(os.path.basename(p))[0]
            with open(p, "r") as f:
                pipeline = json.load(f)
            await es.ingest.put_pipeline(id=name, body=pipeline)
            pipeline_num += 1

    return pipeline_num, "ops"
