#!/usr/bin/env python3

import argparse
import concurrent.futures
import json
import logging
import os
import platform
import shutil
import sys
from collections import namedtuple
from dataclasses import dataclass
from functools import cache
from subprocess import PIPE, Popen

import requests


def setup_logging(level=logging.INFO):
    logging.basicConfig(
        stream=sys.stdout,
        format="%(asctime)s %(levelname)-7s [%(funcName)s:%(lineno)d] %(message)s",
    )
    logging.getLogger().setLevel(level)


INSIDERS = "insiders"
STABLE = "stable"

Release = namedtuple("Release", ["url", "hash"])
CommandResponse = namedtuple("CommandResponse", ["stdout", "stderr", "rc"])

OS_CHOICES = ["linux", "darwin", "windows"]

MAX_ATTEMPTS = 3


class VSCodeApp:
    def __init__(self, channel: str):
        self.channel = channel
        self.parent_app_dir = f"{os.getenv('HOME')}/Dev"
        self.app_dir = f"{self.parent_app_dir}/Visual Studio Code"
        if channel == INSIDERS:
            self.app_dir += f" - " + INSIDERS.title()
        if platform.system().lower() == "darwin":
            self.app_dir += ".app"
        self.cli = f"{self.app_dir}/Contents/Resources/app/bin/code"
        self.attempts = MAX_ATTEMPTS

    def get_installed_version(self) -> str:
        """get the installed version hash"""
        resp = self.run_cmd([self.cli, "--version"])
        stdout = resp.stdout.split("\n")
        for line in stdout:
            if len(line) > 30:
                return line.strip()
        return ""

    def run_cmd(self, cmd: list[str]) -> CommandResponse:
        """Convenience method for running a command and returning the rc, stdout, and stderr"""
        logger = logging.getLogger(__name__)
        output = ["<path>/" + self.cli.split("/")[-1]] + cmd[1:]

        for attempt in range(0, self.attempts):
            prefix = ""
            if attempt > 0:
                prefix = f"[attempt {attempt}/{self.attempts}] "
            logger.info(prefix + " ".join(output))
            p = Popen(cmd, stderr=PIPE, stdout=PIPE)
            stdout, stderr = p.communicate()
            if p.returncode == 0:
                return CommandResponse(stdout.decode(), stderr.decode(), p.returncode)
            if p.returncode:
                logger.warning(stderr.decode())
        raise Exception(
            f"command failed after {self.attempts} attempts: '{' '.join(cmd)}'"
        )

    def download(self, release: Release) -> str:
        """Download the given Release to the current directory"""
        logger = logging.getLogger(__name__)
        filename = f"{os.getcwd()}/VSCode-{release.hash}.zip"
        logger.info(f"Downloading {release.url}...")
        resp = requests.get(release.url, allow_redirects=True, stream=True)
        logger.info(f"Saving to {filename}...")
        with open(filename, "wb") as fh:
            shutil.copyfileobj(resp.raw, fh)
        return filename

    def install(self, filename: str):
        """Install filename"""
        logger = logging.getLogger(__name__)
        logger.info(f"Backing up {self.app_dir}")
        shutil.move(self.app_dir, self.app_dir + ".bak")
        logger.info(f"Extracting {filename} to {self.parent_app_dir}")
        p = Popen(
            ["unzip", filename], stdout=PIPE, stderr=PIPE, cwd=self.parent_app_dir
        )
        stdout, stderr = p.communicate()
        if p.returncode != 0:
            logger.info(stderr)
            return
        new_version = self.get_installed_version()
        logger.info(f"New version: {new_version}")
        shutil.rmtree(self.app_dir + ".bak")
        os.unlink(filename)


def get_os(name: str = ""):
    """Get the OS string"""
    if not name:
        name = platform.system().lower()
    return {
        "darwin": "darwin",
        "windows": "win32-x64-archive",
    }.get(name, "")


def get_download_url(channel: str) -> str:
    """Get the download link for a given channel"""
    return {
        INSIDERS: "https://go.microsoft.com/fwlink/?LinkId=723966",
        STABLE: "https://code.visualstudio.com/sha/download?build=stable&os="
        + get_os(),
    }.get(channel, "")


def get_previous_release(n: int, from_version: str) -> str:
    """Get the Nth release before from_version"""
    releases = list_release_hashes()
    if not from_version:
        return releases[n]
    i = releases.index(from_version) + n
    return releases[i]


def get_release(channel: str, version: str = "") -> Release:
    """Get a release for a given channel and version"""
    logger = logging.getLogger(__name__)
    u = get_download_url(channel)
    resp = requests.get(u, allow_redirects=False)
    if "Location" in resp.headers:
        loc = resp.headers["Location"]
        resp = requests.get(loc, allow_redirects=False)
        if "Location" in resp.headers:
            loc = resp.headers["Location"]
            parts = loc.split("/")
            if version:
                parts[-2] = version
                loc = "/".join(parts)
            return Release(loc, parts[-2])
    return Release("", "")


@cache
def list_release_hashes(os_type: str = "") -> list[str]:
    """List all known release hashes"""
    logger = logging.getLogger(__name__)
    os_type = get_os(os_type)
    u = f"https://update.code.visualstudio.com/api/commits/insider/{os_type}"
    logger.info(f"Getting releases from {u}")
    resp = requests.get(u)
    return json.loads(resp.content.decode())


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--channel", choices=[STABLE, INSIDERS], default=INSIDERS)
    parser.add_argument(
        "--force-version",
        default="",
        help="SHA to download instead of latest available",
    )
    parser.add_argument(
        "--rollback",
        type=int,
        help="roll back N number of releases from currently install release, with 0 being the current release",
    )
    args = parser.parse_args()
    return args


def main():
    logger = logging.getLogger(__name__)
    args = parse_args()
    channel = args.channel
    version = args.force_version
    rollback = args.rollback
    max_workers = 20

    # validate version
    all_releases = list_release_hashes()
    if version and not version in all_releases:
        sys.exit(f"Version not found: {version}")

    app = VSCodeApp(channel)
    installed_version = app.get_installed_version()
    if rollback:
        version = get_previous_release(rollback, installed_version)

    release = get_release(channel, version=version)

    logger.info(f"Channel:    {channel}")
    logger.info(f"Rollback:   {rollback}")
    logger.info(f"Version:    {version}")
    logger.info(f"Installed:  {installed_version}")

    if installed_version != release.hash:
        logger.info(f"Updating to {release.hash}")
        filename = app.download(release)
        app.install(filename)
    else:
        logger.info(f"Latest {channel} version is installed: {installed_version}")


if __name__ == "__main__":
    setup_logging()
    main()
