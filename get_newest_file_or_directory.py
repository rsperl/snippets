#!/usr/bin/env python3

import os


def get_newest(src_dir: str) -> str:
    """return the oldest file or directory"""
    full_path = [src_dir + "/" + item for item in os.listdir(src_dir)]
    newest = max(full_path, key=os.path.getctime)
    return os.path.basename(newest)
