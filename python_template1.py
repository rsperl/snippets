#!/usr/bin/env python3

"""
Documentation about this script or module
"""

import os
import sys
from datetime import datetime
import argparse
import logging
import logging.config
import signal
import time

progname = sys.argv[0]

# https://docs.python.org/3/library/multiprocessing.html


def handle_ctrl_c(signum, frame):
    print(f"filename:    {frame.f_code.co_filename}")
    print(f"line number: {frame.f_lineno}")
    frame_attrs = list(filter(lambda a: not a.startswith("__"), dir(frame)))
    print(f"frame:  {frame_attrs}")
    sys.exit(f"control-c caught (signal number {signum}")


def setup_logging(debug=False):
    # https://docs.python.org/3/library/logging.html
    level = logging.INFO
    if debug:
        level = logging.DEBUG
    logging.basicConfig(
        stream=sys.stdout,
        format="%(asctime)s %(levelname)-7s %(name)s [%(filename)s:%(funcName)s:%(lineno)d] %(message)s",
    )
    logging.getLogger().setLevel(level)


def parseargs() -> argparse.Namespace:
    # https://docs.python.org/3/library/argparse.html
    p = argparse.ArgumentParser()
    p.add_argument(
        "--seconds",
        type=int,
        default=os.getenv("SLEEP_SECONDS") or 10,
        help="seconds to sleep after printing args",
    )
    p.add_argument(
        "-f",
        "--force",
        action="store_true",
        default=os.getenv("FORCE") or False,
        help="force the os_code to be added",
    )
    p.add_argument(
        "--debug",
        action="store_true",
        default=os.getenv("DEBUG") or False,
        help="turn on debug",
    )

    sp = p.add_subparsers(title="actions", required=True, dest="action")

    # action1
    action1 = sp.add_parser("action1", help="do action 1")
    action1.add_argument(
        "-p",
        "--multi-arg",
        nargs="+",
        choices=["a", "b", "c"],
        default=["a", "b"],
        help="option with multiple choices",
    )

    action2 = sp.add_parser("action2", help="do action 2")
    action2.add_argument(
        "--outfile", type=argparse.FileType("w"), default=sys.stdout, help="output file"
    )

    # can be applied to root parser or subparsers
    output = p.add_mutually_exclusive_group()
    output.add_argument(
        "--json", action="store_true", default=False, help="output as json"
    )
    output.add_argument(
        "--csv", action="store_true", default=False, help="output as csv"
    )

    args = p.parse_args()

    # do post-processing
    return args


def main():
    """Called when run as a script"""

    signal.signal(signal.SIGINT, handle_ctrl_c)

    starttime = datetime.now()
    args = parseargs()
    setup_logging(args.debug)
    logger = logging.getLogger(__name__)
    logger.info("### starting")
    logger.info("== ARGS ===")
    for name, value in vars(args).items():
        logger.info(f"{name:10s}: {value}")

    logger.warning(
        f"sleeping for {args.seconds} seconds - hit control-c to invoke signal handler"
    )
    time.sleep(args.seconds)
    # script goes here

    duration = datetime.now() - starttime
    logger.info("### finished in {}s".format(duration))


if __name__ == "__main__":
    main()
