#!/usr/bin/env python

# shwartzian transform to sort list without temporary arrays


list1 = ["aaa", "0000", "z"]

listsorted = map(
    lambda b: b[0],  # final map to return an array of words, now sorted by word length
    sorted(  # sort with custom key function - sort based on word length
        map(  # use map to return array of arrays with length of word
            lambda a: [a, len(a)], list1  # original list
        ),
        key=lambda x: x[1],
    ),
)

listsorted = list(listsorted)
print(f"original:    {list1}")
print(f"normal sort: {sorted(list1)}")
print(f"shwartzian:  {listsorted}")
