import urllib.error
import urllib.request
import re
import json
from argparse import ArgumentParser


URL = "https://registry.hub.docker.com/v1/repositories/{image}/tags"


def main():
    parser = ArgumentParser("docker-tags", description="Show tag names for Docker images")
    parser.add_argument("image",
                        metavar="IMAGE",
                        type=str,
                        help="Docker image name")
    parser.add_argument("--regex",
                        type=str,
                        default=None,
                        help="filter Docker tags with regular expression on tag name")
    args = parser.parse_args()
    url = URL.format(image=args.image)
    pat = re.compile(args.regex or "")

    req = urllib.request.Request(url)
    with urllib.request.urlopen(req) as res:
        data = [x["name"] for x in json.loads(res.read().decode())]

    for name in sorted(filter(pat.search, data)):
        print(name)


if __name__ == "__main__":
    main()
