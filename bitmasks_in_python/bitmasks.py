import pprint


class Bitmask(object):
    def __init__(self, bitdict):
        super(Bitmask, self).__init__()
        self.bitdict = bitdict

    def dump_bits(self):
        return pprint.pprint(self.bitdict)

    def get_mask(self, bits):
        mask = 0
        for b in bits:
            if type(b) == str:
                b = self.bit_value_by_name(b)
            mask = mask | b
        return mask

    def add_bits_by_name(self, mask, bitnames):
        for n in bitnames:
            bit_value = self.bit_value_by_name(n)
            mask = mask | bit_value
        return mask

    def has_bit(self, mask, bit):
        if type(bit) == str:
            bit = self.bit_value_by_name(bit)
        return mask & bit == 0

    def bit_value_by_name(self, name):
        if not self.bitdict.has_key(name):
            raise ValueError("bit name '%s' doesn't exist" % name)
        return self.bitdict.get(name)

    def get_bits(self, mask):
        bits = []
        for n, v in self.bitdict.items():
            if mask & v:
                bits.append({"name": n, "value": v})
        return bits

    def bit_name_by_value(self, value):
        for n, v in self.bitdict.items():
            if v == value:
                return n
        raise ValueError("bit value '%d' doesn't exist" % value)
