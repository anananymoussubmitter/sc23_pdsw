import csv
import json
import re
import sys


def to_json(f):
    for line in f:
        try:
            point = json.loads(line)["location"]
            d = {}
            d["location"] = "POINT (" + str(point[0]) + " " + str(point[1]) + ")"
            print(json.dumps(d))
        except KeyboardInterrupt:
            break
        except Exception as e:
            print(
                "Skipping malformed entry '%s' because of %s" % (line, str(e)),
                file=sys.stderr,
            )


if sys.argv[1] == "json":
    for file_name in sys.argv[2:]:
        with open(file_name) as f:
            to_json(f)
else:
    raise Exception("Expected 'json' but got %s" % sys.argv[1])
