package main

import (
	"flag"
	"log"
	"os"
)

var stringArg string

func init() {
	flag.StringVar(&stringArg, "stringArg", "defaultValue", "this is a string argument")
	flag.Parse()
}

func main() {
	log.Println("Run -h for usage")
	log.Printf("string arg: %s\n", stringArg)
	os.Exit(0)
}
