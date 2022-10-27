package main

import (
	"fmt"
	"strings"
)

// Declare public variables to be set at build-time
var (
	// Local time of build
	BuildTime string

	// Commit SHA
	CommitSHA string

	// Short Commit SHA
	ShortCommitSHA string

	// Build branch (if applicable)
	Branch string

	// Hostname on which build was done
	BuildHostname string

	// Username who did the build
	BuildUsername string

	// Tag of build (if applicable)
	CommitTag string

	// Repository remote
	Repository string
)

// BuildInfo holds the name and value of a build time var
type BuildInfo struct {
	Name  string
	Value string
}

// GetBuildInfo returns a list of BuildInfo containing build time vars
func GetBuildInfo() []BuildInfo {
	return []BuildInfo{
		{Name: "Repository", Value: Repository},
		{Name: "CommitSHA", Value: CommitSHA},
		{Name: "ShortCommitSHA", Value: ShortCommitSHA},
		{Name: "Branch", Value: Branch},
		{Name: "CommitTag", Value: CommitTag},
		{Name: "BuildHostname", Value: BuildHostname},
		{Name: "BuildTime", Value: BuildTime},
		{Name: "BuildUsername", Value: BuildUsername},
	}
}

// GetBuildInfoFormatted returns a list of strings for either printing or logging
func GetBuildInfoFormatted() []string {
	longLine := strings.Replace(fmt.Sprintf("+%61s+", ""), " ", "-", 61)
	content := []string{longLine}
	for _, item := range GetBuildInfo() {
		content = append(content, fmt.Sprintf("| %-17s %-41s |", item.Name+":", item.Value))
	}
	return append(content, longLine)
}

// PrintBuildInfo prints out the build info
func PrintBuildInfo() {
	for _, line := range GetBuildInfoFormatted() {
		fmt.Println(line)
	}
}
