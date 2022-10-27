package main

import (
	"encoding/binary"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
)

func download() string {
	client := &http.Client{}
	req, err := http.NewRequest("GET", downloadURL, nil)
	resp, err := client.Do(req)
	if err != nil {
		fmt.Printf("error downloading new version: %v\n", err)
		os.Exit(1)
	}
	respBody, _ := ioutil.ReadAll(resp.Body)
	defer resp.Body.Close()
	filename := tmpdir + "/calibre.img"
	fh, _ := os.Create(filename)
	err = binary.Write(fh, binary.LittleEndian, respBody)
	return filename
}
