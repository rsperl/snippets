package main

import (
	"fmt"
	"regexp"
	"strings"
)

func main() {
	var versionRe = regexp.MustCompile(`Release: (.+?) `)
	var respBody = `<!DOCTYPE>
    <html><head><body>
    <h2 class="release-title">Release: 1.23 [24 Jan, 2014]</h2>
    <h2 class="release-title">Release: 1.20 [24 Jan, 2014]</h2>
    </body></html>`
	for _, line := range strings.Split(string(respBody), "\n") {
		if strings.Contains(line, "class=\"release-title\"") {
			resultSlice := versionRe.FindStringSubmatch(line)
			if len(resultSlice) > 1 {
				fmt.Println(resultSlice[1])
			}
		}
	}
}