package main

import (
	"context"
	"fmt"
	"time"
)

// Some APIs are designed with context interface, google search is an example. Use context to send cancel signal.

func main() {
	done := make(chan error, 1)
	query := "golang context"
	ctx, cancel := context.WithCancel(context.Background())
	// or use ctx, cancel = context.WithTimeout(context.Background(), queryTimeLimit)
	go func() {
		start := time.Now()
		_, err := google.Search(ctx, query)
		elapsed := time.Since(start)
		fmt.Printf("search time %v", elapsed)
		done <- err
	}()
	select {
	case <-time.After(queryTimeLimit):
		cancel()
		<-done // wait
		fmt.Printf("time out")
	case err := <-done:
		if err != nil {
			panic(err)
		}
	}
	fmt.Printf("Done")
}
