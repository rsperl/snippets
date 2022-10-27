package main

import (
	_ "expvar"
	"fmt"
	"net/http"
	"os"
)

// use expvarmon to monitor:
// https://github.com/divan/expvarmon
// expvarmon -ports=<port>
func init() {
	port := os.Getenv("EXPVARPORT")
	if port != "" {
		go http.ListenAndServe(":", nil)
	}
}
func main() {
	fmt.Println("vim-go")
}
