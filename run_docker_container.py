#!/usr/bin/env python3

import docker
import os
import sys
import base64

image = "registry.com/me/image:1.2.3"
CWD = os.path.abspath(os.path.dirname(__file__))
# DOCKER_HOST=unix://var/run/docker.sock
# DOCKER_TLS_VERIFY
# DOCKER_CERT_PATH
client = docker.from_env(assert_hostname=False)

env = {
    "VAR1": os.getenv("VAR1"),
}

if uservarb64 is not None:
    env["USERVARB64"] = uservarb64

volumes = {
    DIR: {"bind": "/mydirectory", "mode": "rw"},
    CWD + "/tmp": {"bind": "/uservars", "mode": "rw"},
}

# run container
# https://docker-py.readthedocs.io/en/stable/containers.html
cmd = ["bin/app.sh"]
cname = "hello"
c = client.containers.run(
    image=image,
    hostname=cname,
    name=cname,
    command=cmd,
    detach=True,
    environment=env,
    remove=True,
    volumes=volumes,
    working_dir="/playbooks",
)
print(f"Logs for {c.name} ({c.id})")
print("--------------------------------------------------------------------")
for line in c.logs(stream=True, stdout=True, stderr=True, follow=True):
    print(line.decode().strip())
print("--------------------------------------------------------------------")
