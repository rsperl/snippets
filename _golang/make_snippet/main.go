package main

// Create a vscode snippet

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
)

var name string
var prefix string
var filename string

type Snippet struct {
	Prefix string `json:"prefix"`
	Body   string `json:"body"`
}

func errexit(msg string, exit_code int) {
	fmt.Fprintln(os.Stderr, msg)
	os.Exit(exit_code)
}

func usage(msg string) {
	m := `

Create a named VSCode snippet from a file
  
Usage: make_snippet <name> <prefix> <filename>
  
    name:     name of the snippet
    prefix:   string that triggers autocomplete for the snippet
    filename: file containing the snippet code
    
  `
	errexit(msg+m, 1)
	os.Exit(1)
}

func init() {
	flag.Parse()
	if name = flag.Arg(0); name == "" {
		usage("a snippet name is required")
	}
	if prefix = flag.Arg(1); prefix == "" {
		usage("a prefix is required")
	}
	if filename = flag.Arg(2); filename == "" {
		usage("a filename is required")
	}
	if _, err := os.Stat(filename); err != nil {
		usage("could not read file " + filename)
	}
}

func main() {
	body, err := os.ReadFile(filename)
	if err != nil {
		errexit(fmt.Sprintf("failed to read file %s: %v", filename, err), 1)
	}
	snippet := Snippet{Prefix: prefix, Body: string(body)}
	output, err := json.MarshalIndent(snippet, "", "    ")
	if err != nil {
		errexit("failed to create json snippet: "+err.Error(), 1)
	}
	fmt.Printf("\n\"%s\": %s\n\n", name, string(output))
	os.Exit(0)
}
