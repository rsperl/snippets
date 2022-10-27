#!/usr/bin/env python
# -*- coding: utf-8 -*-


# example output:
#
#  A.var1             c_int(1) 4509637024
#  a1.var1            c_int(3) 4509637704 False
#  a1.__class__.var1  c_int(1) 4509637024 True
#  --------------------------------------------------------------------
#  A.var1             c_int(1) 4509637024
#  a1.var1            c_int(4) 4508426800 False
#  a1.__class__.var1  c_int(1) 4509637024 True
#  --------------------------------------------------------------------
#  A.var1             c_int(1) 4509637024
#  b1.var1            c_int(4) 4509637840 False
#  b1.__class__.var1  c_int(1) 4509637024 True


import ctypes


class A:

    # static class variable
    var1 = ctypes.c_int(1)

    def __init__(self):
        # instance variable distinct from class variable of same name
        self.var1 = ctypes.c_int(2)


a1 = A()

# this only modifies the instance variable, not the class variable
a1.var1 = ctypes.c_int(3)

sep = "--------------------------------------------------------------------"
fmt = "{:18s} {} {} {}"
class_var_addr = ctypes.addressof(A.var1)

print(fmt.format("A.var1", A.var1, class_var_addr, ""))
print(
    fmt.format(
        "a1.var1",
        a1.var1,
        ctypes.addressof(a1.var1),
        ctypes.addressof(a1.var1) == class_var_addr,
    )
)
print(
    fmt.format(
        "a1.__class__.var1",
        a1.__class__.var1,
        ctypes.addressof(a1.__class__.var1),
        ctypes.addressof(a1.__class__.var1) == class_var_addr,
    )
)
print(sep)

# only modifies the instance variable
a1.var1 = ctypes.c_int(4)

print(fmt.format("A.var1", A.var1, class_var_addr, ""))
print(
    fmt.format(
        "a1.var1",
        a1.var1,
        ctypes.addressof(a1.var1),
        ctypes.addressof(a1.var1) == class_var_addr,
    )
)
print(
    fmt.format(
        "a1.__class__.var1",
        a1.__class__.var1,
        ctypes.addressof(a1.__class__.var1),
        ctypes.addressof(a1.__class__.var1) == class_var_addr,
    )
)
print(sep)

b1 = A()
# again, modifies only the instance variable
b1.var1 = ctypes.c_int(5)
print(fmt.format("A.var1", A.var1, class_var_addr, ""))
print(
    fmt.format(
        "b1.var1",
        a1.var1,
        ctypes.addressof(b1.var1),
        ctypes.addressof(b1.var1) == class_var_addr,
    )
)
print(
    fmt.format(
        "b1.__class__.var1",
        b1.__class__.var1,
        ctypes.addressof(b1.__class__.var1),
        ctypes.addressof(b1.__class__.var1) == class_var_addr,
    )
)
