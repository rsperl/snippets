package main

import "sync"

var (
	r    *repository
	once sync.Once
)

func Repository() *repository {
	if r == nil {
		once.Do(func() {
			r = &repository{
				items: make(map[string]string),
			}
		})
	}
	return r
}
