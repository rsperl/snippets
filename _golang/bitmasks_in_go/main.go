package main

import "sort"

type Decoder struct {
	Flags map[string]int
}

func NewDecoder(flags map[string]int) *Decoder {
	return &Decoder{Flags: flags}
}

func (d *Decoder) GetFlags(b int) []string {
	var flags []string
	for n, v := range d.Flags {
		if b&v != 0 {
			flags = append(flags, n)
		}
	}
	sort.Strings(flags)
	return flags
}

func (d *Decoder) HasFlag(b int, flag string) (bool, bool) {
	if val, ok := d.Flags[flag]; ok {
		return b&val != 0, ok
	}
	return false, false
}

func (d *Decoder) HasFlags(b int, flags []string) (bool, bool) {
	for _, f := range flags {
		if val, ok := d.HasFlag(b, f); !val || !ok {
			return val, ok
		}
	}
	return true, true
}

func (d *Decoder) AddFlagsByName(b int, flags []string) (int, bool) {
	for _, f := range flags {
		if val, ok := d.Flags[f]; ok {
			b |= val
		} else {
			return -1, false
		}
	}
	return b, true
}

func (d *Decoder) RemoveFlagsByName(b int, flags []string) (int, bool) {
	for _, f := range flags {
		if val, ok := d.Flags[f]; ok {
			b &^= val
		} else {
			return -1, false
		}
	}
	return b, true
}
