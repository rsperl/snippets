package main

import (
	"fmt"
	"os"
	"strconv"
	"time"
)

const (
	NsFactor          int64 = 10000000
	SecsBetweenEpochs int64 = 11644473600
)

// Convert filetime to time.Time
func FiletimeToDate(filetime int64) time.Time {
	// convert filetime to seconds, then subtract the seconds from 1601
	// to get epoch seconds
	return time.Unix(filetime/NsFactor-SecsBetweenEpochs, 0)
}

func main() {
	filetime, err := strconv.ParseInt(os.Args[1], 10, 64)
	if err != nil {
		fmt.Printf("error converting converting to integer: %s\n", os.Args[1])
		os.Exit(1)
	}
	fmt.Printf("%v\n", FiletimeToDate(filetime))
	os.Exit(0)
}
