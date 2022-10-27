package main

import (
	"fmt"
	"log"
	"net"
	"os"
	"regexp"
	"strconv"
	"time"
)

// CheckPort checks a given port on a given host and returns a boolean to indicate port status
// and an error if one occured. The error could be a timeout (box is offline) or connection refused
// (port closed), or if the ulimit is not properly set, it could be "too many open files"
func CheckPort(hostname string, p int64) (bool, error) {
	i := fmt.Sprintf("%s:%d", hostname, p)
	timeout := time.Duration(3) * time.Second
	c, err := net.DialTimeout("tcp", i, timeout)
	if err != nil {
		return false, err
	}
	defer c.Close()
	return true, nil
}

// collect args and ensure ports are integers
func getArgs(args []string) (hostname string, ports []int64) {
	hostname = os.Args[1]
	for _, s := range os.Args[2:] {
		p, err := strconv.ParseInt(s, 10, 64)
		if err != nil {
			panic(fmt.Errorf("could not parse port as int: %s\n", s))
		}
		ports = append(ports, p)
	}
	return hostname, ports
}

func main() {
	if len(os.Args) < 2 {
		fmt.Printf("Usage: %s <hostname> <port1> <port2> ...\n", os.Args[0])
		os.Exit(1)
	}
	hostname, ports := getArgs(os.Args)

	log.Printf("Hostname: %s\n", hostname)
	log.Printf("Ports:    %v\n", ports)

	for _, port := range ports {
		isOpen, err := CheckPort(hostname, port)
		hostport := fmt.Sprintf("[%s:%d]:", hostname, port)
		if err != nil {
			if err, ok := err.(net.Error); ok && err.Timeout() {
				log.Printf("%s port timeout", hostport)
			} else if match, _ := regexp.MatchString(".*connection refused.*", err.Error()); match {
				log.Printf("%s port closed", hostport)
			} else if match, _ := regexp.MatchString(".*too many open files*", err.Error()); match {
				log.Fatalf("%s %v", hostport, err)
			} else {
				log.Fatalf("%s unknown error: %v", hostport, err)
			}
		} else if isOpen {
			log.Printf("%s port open", hostport)
		} else {
			log.Printf("%sport closed, but no error", hostport)
		}
	}
}
