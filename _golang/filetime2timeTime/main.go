package main

import (
	"fmt"
	"math"
	"os"
	"strconv"
	"time"
)

func main() {

	if len(os.Args) != 2 {
		fmt.Println("Usage: ft2date <filetime>")
		os.Exit(1)
	}
	ft, err := strconv.ParseInt(os.Args[1], 10, 64)
	if err != nil {
		fmt.Println("invalid date time")
		os.Exit(1)
	}
	t := getTime(ft)
	fmt.Println(t)
	fmt.Println(t.Local())
}

func getTime(input int64) time.Time {
	maxd := time.Duration(math.MaxInt64).Truncate(100 * time.Nanosecond)
	maxdUnits := int64(maxd / 100) // number of 100-ns units

	t := time.Date(1601, 1, 1, 0, 0, 0, 0, time.UTC)
	for input > maxdUnits {
		t = t.Add(maxd)
		input -= maxdUnits
	}
	if input != 0 {
		t = t.Add(time.Duration(input * 100))
	}
	return t
}
