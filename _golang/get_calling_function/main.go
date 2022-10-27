package main

import (
	"fmt"
	"runtime"
)

// whoCalledMe is a function that returns the name, fileName, and lineNumber of the caller that called function X
// the code doesn't check for edge cases
func whoCalledMe() (callerName, callerFileName string, callerLineNumber int) {
	// program counters, only interested in 1 pc, the pc of my caller
	pc := make([]uintptr, 1)
	// skip == 0 is runtime.Callers itself
	// skip == 1 is this function that called runtime.Callers
	// skip == 2 is the function that called this function, call it X
	// skip == 3 is the function that called X
	runtime.Callers(3, pc)
	// by now, pc contains number x such that x is the pc of the caller
	// we call runtime.CallersFrames to get the stack frames of all program counters in pc
	frames := runtime.CallersFrames(pc)
	// extract the caller's frame
	f, _ := frames.Next()

	callerName, callerFileName, callerLineNumber = f.Function, f.File, f.Line
	return
}

func helloStranger() {
	callerName, callerFileName, callerLineNum := whoCalledMe()
	fmt.Printf("This function called me: %v\n", callerName)
	fmt.Printf("It's located in: %v on line: %v\n", callerFileName, callerLineNum)
}

func main() {
	helloStranger()
}

// output
// This function called me: main.main
// It's located in: C:/Users/x/y/z/main.go on line: 33
