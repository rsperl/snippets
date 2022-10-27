from pprint import pprint as pp
import sys
import os
import pytest

libpath = os.getcwd() + "/lib"
sys.path.append(libpath)
import bitmask_uac

uac = bitmask_uac.UacParser()


@pytest.fixture
def parse_bitmask():
    return (
        {
            "name": "normal account",
            "setup": {"mask": 512, "bits": {512: 1, 2: 0}},
            "expected": {"bits": ({"name": "NORMAL_ACCOUNT", "value": 512})},
        },
        {
            "name": "weird account",
            "setup": {"mask": 66050, "bits": {512: 1, 2: 1, 65536: 1, 4194304: 0}},
            "expected": {
                "bits": (
                    {"name": "ACCOUNTDISABLE", "value": 2},
                    {"name": "DONT_EXPIRE_PASSWORD", "value": 65536},
                    {"name": "NORMAL_ACCOUNT", "value": 512},
                )
            },
        },
    )


def test_parsing(parse_bitmask):
    print("parse_bitmask: " + str(parse_bitmask))
    for tc in parse_bitmask:
        n, s, e = tc["name"], tc["setup"], tc["expected"]
        mask = s["mask"]
        assert (uac.get_bits(mask) == e["bits"], n + ": compare bits")
        for bit_value, should_be_there in s["bits"].items():
            msg = n + ": has bit " + str(bit_value)
            assert (uac.has_bit(mask, bit_value) == should_be_there, msg)
