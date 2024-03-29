def log2(x):
    if x == 0:
        return False
    return math.log10(x) / math.log10(2)


def is_power_of_two(n):
    return math.ceil(log2(n)) == math.floor(log2(n))
