package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello from Go server on port 8090!\n")
	})
	log.Println("Go server listening on :8090")
	log.Fatal(http.ListenAndServe(":8090", nil))
}
